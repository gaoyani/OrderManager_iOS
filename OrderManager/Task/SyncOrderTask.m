//
//  SyncOrderTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "SyncOrderTask.h"
#import "Constants.h"
#import "UrlConstants.h"
#import "Utils.h"
#import "OrderInfo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

@implementation SyncOrderTask {
    NetConnection* netConnection;
    AppDelegate* appDelegate;
    NSString* resposeFuncName;
}

-(SyncOrderTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    resposeFuncName = @"syncOrderResult";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncOrderResult:) name:resposeFuncName object:nil];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    return  self;
}

-(void)getOrders {
//    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
    [dataDic setValue:[Utils getDeviceUUID] forKey:@"mac"];
    
//    
//    [paramsDic setValue:@"1.0" forKey:@"ver"];
//    NSString* serial = [Utils getRandomString:32];
//    [paramsDic setValue:serial forKey:@"serial"];
//    [paramsDic setValue:dataDic forKey:@"params"];
//    [paramsDic setValue:@"listorder" forKey:@"method"];
//    NSString* auth = [NSString stringWithFormat:@"%@%@",serial,[Utils md5:@"listorder"]];
//    [paramsDic setValue:[Utils md5:auth] forKey:@"auth"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 5;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [netConnection.manager POST:[UrlConstants getServerUrl] parameters:[netConnection getParamsDictionary:dataDic methodName:@"listorder"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            [userInfoDic setValue:resultDic forKey:message];
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        //        [self.delegate NetConnectionResult:userInfoDic];
        [self NetConnectionResult:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", NSLocalizedString(@"connect_error", nil));
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        //        [self.delegate NetConnectionResult:errorInfoDic];
        [self NetConnectionResult:errorInfoDic];
    }];

    
    
//    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
//    [netConnection startConnect:[UrlConstants getServerUrl] dataDictionary:dataDic methodName:@"listorder" resposeFuncName:resposeFuncName];
}

-(void)NetConnectionResult:(NSMutableDictionary *)result {
    NSString* resultName = @"updateOrderList";
    
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    if (isSucceed) {
        NSDictionary* resultDic = [result objectForKey:message];
        int oldNewNum = [self getNewOrderNum];
        [appDelegate.unconfirmOrderList removeAllObjects];
        [appDelegate.confirmOrderList removeAllObjects];
        [appDelegate.confirmTableIDList removeAllObjects];
        
        
        NSDictionary* jsonDic = [resultDic objectForKey:@"params"];
        if (![jsonDic isKindOfClass:[NSString class]]) {
            NSArray* jsonArray = [jsonDic objectForKey:@"orders"];
            int curNewNum = 0;
            BOOL hasNewOrder = NO;
            NSString* curTableID = @"";
            for (NSDictionary* orderDic in jsonArray) {
                OrderInfo* orderInfo = [[OrderInfo alloc] init];
                [orderInfo parseJson:orderDic];
                
                if (orderInfo.type == OrderTypeOrder && orderInfo.state == OrderStateConfirm) {
                    if (![curTableID isEqualToString:orderInfo.tableId]) {
                        NSMutableArray* orderList = [NSMutableArray array];
                        [orderList addObject:orderInfo];
                        [appDelegate.confirmOrderList setValue:orderList forKey:orderInfo.tableId];
                        [appDelegate.confirmTableIDList addObject:orderInfo.tableId];
                        curTableID = orderInfo.tableId;
                    } else {
                        [((NSMutableArray*)[appDelegate.confirmOrderList valueForKey:orderInfo.tableId]) addObject:orderInfo];
                    }
                } else {
                    [appDelegate.unconfirmOrderList addObject:orderInfo];
                }
                
                if (orderInfo.state == OrderStateNew) {
                    hasNewOrder = YES;
                    curNewNum++;
                }
            }
            
            if (hasNewOrder) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound(1000);
                
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                if (curNewNum > oldNewNum && (state != UIApplicationStateActive)) {
                    UILocalNotification *notif = [[UILocalNotification alloc] init];
                    notif.fireDate = [NSDate date];
                    notif.timeZone = [NSTimeZone localTimeZone];
                    notif.alertBody= NSLocalizedString(@"has_new_order_note", nil);
                    
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];                    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                    notif.alertAction = app_Name;
                    notif.soundName= UILocalNotificationDefaultSoundName;
                    notif.applicationIconBadgeNumber = ([UIApplication sharedApplication].applicationIconBadgeNumber + 1);
                    notif.userInfo = [NSDictionary dictionaryWithObject:notif.alertBody forKey:@"kActivityNearByTotal"];
                    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                }
            }
        }
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:NSLocalizedString(@"list_order_fail", nil) forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:resultName object:self userInfo:userInfoDic];
    
}

-(int)getNewOrderNum {
    int num = 0;
    for (OrderInfo* info in appDelegate.unconfirmOrderList) {
        if(info.state == OrderStateNew) {
            num++;
        }
    }
    
    return num;
}

@end
