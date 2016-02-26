//
//  LogoutTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/19.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "LogoutTask.h"
#import "UrlConstants.h"
#import "Constants.h"

@implementation LogoutTask {
    NetConnection* netConnection;
    NSString* resposeFuncName;
}

-(LogoutTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    resposeFuncName = @"logoutResult";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutResult:) name:resposeFuncName object:nil];
    
    return  self;
}

-(void)logout {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
    //    [dataDic setValue:[Utils md5:password] forKey:@"password"];
    
//    [netConnection startConnect:[UrlConstants getLogoutUrl] dataDictionary:dataDic methodName:@"logout" resposeFuncName:resposeFuncName];
    [netConnection.manager POST:[UrlConstants getLogoutUrl
                                 ] parameters:[netConnection getParamsDictionary:dataDic methodName:@"logout"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
            NSString* resultFlag = [jsonDic objectForKey:@"logoutflag"];
            if ([resultFlag isEqualToString:@"success"]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:NSLocalizedString(@"logout_fail", nil) forKey:errorMessage];
            }        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:resposeFuncName object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:resposeFuncName object:self userInfo:errorInfoDic];
    }];

}

//-(void)logoutResult:(NSNotification *)notification {
//    NSString* loginFail = NSLocalizedString(@"logout_fail", nil);
//    
//    NSDictionary* result = notification.userInfo;
//    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
//    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
//    if (isSucceed) {
//        NSDictionary* resultDic = [result objectForKey:message];
//        NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
//        NSString* resultFlag = [jsonDic objectForKey:@"logoutflag"];
//        if ([resultFlag isEqualToString:@"success"]) {
//            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
//        } else {
//            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//            [userInfoDic setValue:loginFail forKey:errorMessage];
//        }
//        
//    } else {
//        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
//        [userInfoDic setValue:loginFail forKey:errorMessage];
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:resposeFuncName object:self userInfo:userInfoDic];
//    
//}


@end
