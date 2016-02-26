//
//  OrderInfo.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderInfo.h"
#import "UrlConstants.h"
#import "Constants.h"
#import "PreferInfo.h"

@implementation OrderInfo {
    NetConnection* netConnection;
    enum TaskType taskType;
//    NSString* resposeFuncName;
}


-(OrderInfo*)init {
    self = [super init];
    if (self) {
        self.orderID = -1;
        self.dishesList = [NSMutableArray array];
        self.isAddOrder = NO;
        self.isTakeOutOrder = NO;
        
        netConnection = [[NetConnection alloc] init];
//        resposeFuncName = @"operationResult";
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(operationResult:) name:resposeFuncName object:nil];
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    OrderInfo* info = [[OrderInfo allocWithZone:zone] init];
    info.orderID = self.orderID;
    info.tableId = self.tableId;
    info.tableName = self.tableName;
    info.content = self.content;
    info.notes = self.notes;
    info.state = self.state;
    info.type = self.type;
    info.isVip = self.isVip;
    info.waiterId = self.waiterId;
    info.isAddOrder = self.isAddOrder;
    info.isTakeOutOrder = self.isTakeOutOrder;
    
    for (OrderdDishesInfo* dishesInfo in self.dishesList) {
        [info.dishesList addObject:[dishesInfo copy]];
    }
    
    return info;
}

//public String getPrice() {
//    return "50";
//}

-(int)getDishesNum {
    int totalNum = 0;
    for (OrderdDishesInfo* info in self.dishesList) {
        int num = [info.orderNum intValue];
        totalNum += num;
    }
    
    return totalNum;
}

-(OrderdDishesInfo*)findOrderedDishes:(NSString*)dishesId {
    for (OrderdDishesInfo* info in self.dishesList) {
        if ([info.dishesID isEqualToString:@"0"]) {
            if ([info.name isEqualToString:dishesId])
                return info;
        } else {
            if ([info.dishesID isEqualToString:dishesId])
                return info;
        }
    }
    
    return nil;
}

-(BOOL)isOrderEmpty {
    if (self.dishesList.count == 0) {
        return YES;
    } else {
        for (OrderdDishesInfo* info in self.dishesList) {
            if (![info.orderNum isEqualToString:@"0"]) {
                return NO;
            }
        }
        
        return YES;
    }
}

-(BOOL)hasSoldOutDishes {
    for (OrderdDishesInfo* info in self.dishesList) {
        if (info.isSoldOut && [info.orderNum intValue] > 0) {
            return YES;
        }
    }
    
    return NO;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.orderID = [[jsonDic objectForKey:@"id"] intValue];
    self.content = [jsonDic objectForKey:@"content"];
    self.tableId = [jsonDic objectForKey:@"table_id"];
    self.tableName = [jsonDic objectForKey:@"table_name"];
    self.type = [[jsonDic objectForKey:@"type"] intValue];
    self.state = [[jsonDic objectForKey:@"status"] intValue];
    self.isVip = ([[jsonDic objectForKey:@"is_vip"] intValue] == 1);
    self.isTakeOutOrder = ([[jsonDic objectForKey:@"waimai"] intValue] == 1);
}

-(void)deleteOrder {
    taskType = TaskTypeDelete;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[NSNumber numberWithInt:self.orderID] forKey:@"order_id"];

    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"orderrepeal"]];
    
}

-(void)changeState:(enum OrderState)orderState {
    taskType = TaskTypeChangeState;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
    [dataDic setValue:[NSNumber numberWithInt:self.orderID] forKey:@"id"];
    [dataDic setValue:[NSNumber numberWithInt:(self.isTakeOutOrder ? 1 : 0)] forKey:@"waimai"];
    [dataDic setValue:[NSNumber numberWithInt:orderState] forKey:@"status"];

    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"setinfostatus"]];
}

-(void)printAccount {
    taskType = TaskTypePrintAccount;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:self.tableId forKey:@"table_id"];
    [dataDic setValue:self.content forKey:@"order_id"];
    
    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"invoicing"]];
}

-(void)getOrderedDishes {
    taskType = TaskTypeGetOrderedDishes;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:self.content forKey:@"orderid"];
    [dataDic setValue:[NSNumber numberWithInt:(self.isTakeOutOrder ? 1 : 0)] forKey:@"waimai"];
    
    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"getorderbyid"]];
}

-(void)uploadOrder {
    
    taskType = TaskTypeUploadOrder;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
    [dataDic setValue:self.content forKey:@"orderid"];
    [dataDic setValue:self.tableId forKey:@"tableid"];
    [dataDic setValue:self.notes forKey:@"order_text"];
    [dataDic setValue:(self.isVip ? @"1" : @"0") forKey:@"is_vip"];
    [dataDic setValue:[NSNumber numberWithBool:self.isAddOrder] forKey:@"is_add_order"];
    [dataDic setValue:[NSNumber numberWithInt:(self.isTakeOutOrder ? 1 : 0)] forKey:@"waimai"];
    
    NSMutableArray* dishesArray = [NSMutableArray array];
    for (OrderdDishesInfo* info in self.dishesList) {
        NSMutableDictionary *dishesDic = [[NSMutableDictionary alloc] init];
        [dishesDic setValue:info.isInput ? @"0" : info.dishesID forKey:@"menuid"];
        [dishesDic setValue:info.name forKey:@"name"];
        [dishesDic setValue:info.price forKey:@"price"];
        [dishesDic setValue:info.vipPrice forKey:@"vipprice"];
        [dishesDic setValue:info.islimit forKey:@"islimit"];
        [dishesDic setValue:info.orderNum forKey:@"count"];
        
        NSMutableArray* preferArray = [NSMutableArray array];
        for (PreferInfo* preferInfo in info.preferList){
            if (preferInfo.isChecked) {
                [preferArray addObject:[NSNumber numberWithInt:preferInfo.preferID]];
            }
        }
        [dishesDic setValue:preferArray forKey:@"phids"];
        [dishesDic setValue:info.otherPrefer forKey:@"other_prefer"];
        [dishesArray addObject:dishesDic];
    }
    
    [dataDic setValue:dishesArray forKey:@"updatemenus"];
    
    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"updateorder"]];
}

-(void)addOrder {
    taskType = TaskTypeAddOrder;
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:userIDKey] forKey:@"user_id"];
    [dataDic setValue:self.tableId forKey:@"table_id"];
    [dataDic setValue:self.notes forKey:@"order_text"];
    [dataDic setValue:(self.isVip ? @"1" : @"0") forKey:@"is_vip"];
    [dataDic setValue:[NSNumber numberWithBool:self.isAddOrder] forKey:@"is_add_order"];
//    [dataDic setValue:[NSNumber numberWithInt:(self.isTakeOutOrder ? 1 : 0)] forKey:@"waimai"];
    
    NSMutableArray* dishesArray = [NSMutableArray array];
    for (OrderdDishesInfo* info in self.dishesList) {
        NSMutableDictionary *dishesDic = [[NSMutableDictionary alloc] init];
        [dishesDic setValue:info.isInput ? @"0" : info.dishesID forKey:@"menuid"];
        [dishesDic setValue:info.name forKey:@"name"];
        [dishesDic setValue:info.price forKey:@"price"];
        [dishesDic setValue:info.vipPrice forKey:@"vipprice"];
        [dishesDic setValue:info.islimit forKey:@"islimit"];
        [dishesDic setValue:info.orderNum forKey:@"count"];

        NSMutableArray* preferArray = [NSMutableArray array];
        for (PreferInfo* preferInfo in info.preferList){
            if (preferInfo.isChecked) {
                [preferArray addObject:[NSNumber numberWithInt:preferInfo.preferID]];
            }
        }
        [dishesDic setValue:preferArray forKey:@"phids"];
        [dishesDic setValue:info.otherPrefer forKey:@"other_prefer"];
        [dishesArray addObject:dishesDic];
    }
    
    [dataDic setValue:dishesArray forKey:@"menus"];
    
    [self startConnect:[netConnection getParamsDictionary:dataDic methodName:@"addorder"]];
}

-(void)startConnect:(NSDictionary*)paramsDic {
    [netConnection.manager POST:[UrlConstants getServerUrl] parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        
        [self operationResult:userInfoDic];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSMutableDictionary *errorInfoDic = [[NSMutableDictionary alloc] init];
        [errorInfoDic setValue:NSLocalizedString(@"connect_error", nil) forKey:errorMessage];
        [errorInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [self operationResult:errorInfoDic];
    }];

}

-(void)operationResult:(NSMutableDictionary *)result {
    NSString* failMessage = NSLocalizedString(@"order_process_fail", nil);
    NSString* resultName = @"getDetailResult";
    if (taskType == TaskTypeDelete) {
        failMessage = NSLocalizedString(@"order_delete_fail", nil);
        resultName = @"operateResult";
    } else if (taskType == TaskTypeChangeState || taskType == TaskTypePrintAccount) {
        failMessage = NSLocalizedString(@"order_process_fail", nil);
        resultName = @"operateResult";
    } else if (taskType == TaskTypeUploadOrder || taskType == TaskTypeAddOrder) {
        failMessage = NSLocalizedString(@"submit_failed", nil);
        resultName = @"uploadOrderResult";
    }
    
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:[NSNumber numberWithInt:self.orderID] forKey:@"order_id"];
    BOOL isSucceed = [[result objectForKey:succeed] boolValue];
    if (isSucceed) {
        NSDictionary* resultDic = [result objectForKey:message];
        if (taskType == TaskTypeDelete || taskType == TaskTypeChangeState) {
            NSString* result = [resultDic objectForKey:@"params"];
            if ([result isEqualToString:@"success"]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else if ([result isEqualToString:@"opered"]) {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:NSLocalizedString(@"order_delete_fail", nil) forKey:errorMessage];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:failMessage forKey:errorMessage];
            }
        } else if (taskType == TaskTypePrintAccount) {
            NSString* result = [resultDic objectForKey:@"params"];
            if ([result isEqualToString:@"success"]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:result forKey:errorMessage];
            }

        } else if (taskType == TaskTypeGetOrderedDishes) {
            NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
            if (jsonDic != nil) {
                [self.dishesList removeAllObjects];
                NSArray* jsonArray = [jsonDic objectForKey:@"menus"];
                for (NSDictionary* dishesDic in jsonArray) {
                    OrderdDishesInfo* dishesInfo = [[OrderdDishesInfo alloc] init];
                    [dishesInfo parseJson:dishesDic];
                    [self.dishesList addObject:dishesInfo];
                }
                self.content = [jsonDic objectForKey:@"orderid"];
                self.tableId = [[jsonDic objectForKey:@"tableid"] stringValue];
                self.notes = [jsonDic objectForKey:@"order_text"];
                if (self.isTakeOutOrder) {
                    self.contactName = [jsonDic objectForKey:@"customer"];
                    self.contactNumber = [jsonDic objectForKey:@"ordertelid"];
                    self.contactAddress = [jsonDic objectForKey:@"addr"];
                    self.sendType = [jsonDic objectForKey:@"mode"];
                    self.sendTime = [jsonDic objectForKey:@"sendtime"];
                }
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:failMessage forKey:errorMessage];
            }
        } else {
            NSString* result = @"";
            if (taskType == TaskTypeAddOrder) {
                result = [resultDic objectForKey:@"params"];
            } else {
                NSDictionary *jsonDic = [resultDic objectForKey:@"params"];
                result = [jsonDic objectForKey:@"message"];
            }
            
            if ([result isEqualToString:@"success"]) {
                [userInfoDic setValue:[NSNumber numberWithBool:YES] forKey:succeed];
            } else {
                [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
                [userInfoDic setValue:result forKey:errorMessage];
            }
        }
        
    } else {
        [userInfoDic setValue:[NSNumber numberWithBool:NO] forKey:succeed];
        [userInfoDic setValue:failMessage forKey:errorMessage];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:resultName object:self userInfo:userInfoDic];
    
}


@end
