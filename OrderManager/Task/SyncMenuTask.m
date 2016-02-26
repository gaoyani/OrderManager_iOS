//
//  SyncMenuTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "SyncMenuTask.h"
#import "NetConnection.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "DishesInfo.h"

@implementation SyncMenuTask {
    NetConnection* netConnection;
//    NSMutableArray* newOrders;
//    NSMutableArray* confirmOrders;
//    NSString* resposeFuncName;
}

-(SyncMenuTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    
    return  self;
}


-(void)syncMenu:(NSMutableArray*)dishesList {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [netConnection.manager POST:[UrlConstants getServerUrl] parameters:[netConnection getParamsDictionary:dataDic methodName:@"rsyncmenu"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            [userInfoDic setValue:resultDic forKey:message];
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            NSDictionary* jsonDic = [resultDic objectForKey:@"params"];
            if (jsonDic != nil) {
                [dishesList removeAllObjects];
                NSArray* jsonArray = [jsonDic objectForKey:@"menulist"];
                for (NSDictionary* dishesDic in jsonArray) {
                    DishesInfo* dishesInfo = [[DishesInfo alloc] init];
                    [dishesInfo parseJson:dishesDic];
//                    [dishesList setObject:dishesInfo forKey:dishesInfo.dishesID];
                    [dishesList addObject:dishesInfo];
                }
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:NSLocalizedString(@"sync_menu_fail", nil) forKey:errorMessage];
            }
        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncMenuResult" object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", NSLocalizedString(@"connect_error", nil));
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"syncMenuResult" object:self userInfo:errorInfoDic];
    }];

}

@end
