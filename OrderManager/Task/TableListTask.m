//
//  TableListTask.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/26.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "TableListTask.h"
#import "NetConnection.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "TableInfo.h"

@implementation TableListTask {
    NetConnection* netConnection;
}

-(TableListTask*)init {
    self = [super init];
    
    netConnection = [[NetConnection alloc] init];
    
    return self;
}

-(void)getTableList:(NSString*)tableID tableList:(NSMutableArray*)tableList {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:tableID forKey:@"table_id"];
    
    [netConnection.manager POST:[UrlConstants getServerUrl] parameters:[netConnection getParamsDictionary:dataDic methodName:@"tables"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];
        
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (resultDic != nil && error == nil) {
            [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
            [tableList removeAllObjects];
            NSArray* jsonArray = [jsonDic objectForKey:@"tables"];
            for (NSDictionary* tableDic in jsonArray) {
                TableInfo* tableInfo = [[TableInfo alloc] init];
                tableInfo.tableID = [tableDic objectForKey:@"id"];
                tableInfo.name = [tableDic objectForKey:@"name"];
                [tableList addObject:tableInfo];
            }
        } else {
            [userInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
            [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[tableID isEqualToString:@""] ? @"freeTableListResult" : @"allTableListResult" object:self userInfo:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [[NSNotificationCenter defaultCenter] postNotificationName:[tableID isEqualToString:@""] ? @"freeTableListResult" : @"allTableListResult" object:self userInfo:errorInfoDic];
    }];
}


@end
