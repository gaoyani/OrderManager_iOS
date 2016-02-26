//
//  CommonInfoTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "CommonInfoTask.h"
#import "NetConnection.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "CategoryInfo.h"
#import "PreferInfo.h"

@implementation CommonInfoTask {
    NetConnection* netConnection;
}

-(CommonInfoTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    
    return  self;
}


-(void)getInfo:(NSMutableArray*)categoryList preferList:(NSMutableDictionary*)preferList {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [netConnection.manager POST:[UrlConstants getServerUrl] parameters:[netConnection getParamsDictionary:dataDic methodName:@"typelist"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                [categoryList removeAllObjects];
                [preferList removeAllObjects];
                CategoryInfo* categoryAll = [[CategoryInfo alloc] init];
                categoryAll.categoryID = 0;
                categoryAll.name = NSLocalizedString(@"all", nil);
                [categoryList addObject:categoryAll];
                NSArray* categoryArray = [jsonDic objectForKey:@"typelist"];
                for (NSDictionary* categoryDic in categoryArray) {
                    CategoryInfo* categoryInfo = [[CategoryInfo alloc] init];
                    categoryInfo.categoryID = [[categoryDic objectForKey:@"id"] intValue];
                    categoryInfo.name = [categoryDic objectForKey:@"name"];
                    [categoryList addObject:categoryInfo];
                }
                
                NSArray* preferArray = [jsonDic objectForKey:@"phlist"];
                for (NSDictionary* preferDic in preferArray) {
                    PreferInfo* preferInfo = [[PreferInfo alloc] init];
                    preferInfo.preferID = [[preferDic objectForKey:@"id"] intValue];
                    preferInfo.name = [preferDic objectForKey:@"name"];
                    [preferList setObject:preferInfo forKey:[NSString stringWithFormat:@"%d",preferInfo.preferID]];
                }
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:NSLocalizedString(@"get_info_fail", nil) forKey:errorMessage];
            }
        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getInfoResult" object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", NSLocalizedString(@"connect_error", nil));
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getInfoResult" object:self userInfo:errorInfoDic];
    }];
    
}

@end
