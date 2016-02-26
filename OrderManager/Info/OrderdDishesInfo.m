//
//  OrderdDishesInfo.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderdDishesInfo.h"
#import "AppDelegate.h"
#import "PreferInfo.h"

@implementation OrderdDishesInfo

-(OrderdDishesInfo*)init {
    self = [super init];
    if (self) {
        self.orderNum = @"1";
        self.isInput = NO;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    OrderdDishesInfo* info = [[OrderdDishesInfo allocWithZone:zone] init];
    
    info.dishesID = self.dishesID;
    info.name = self.name;
    info.category = self.category;
    info.price = self.price;
    info.vipPrice = self.vipPrice;
    info.islimit = self.islimit;
    info.preference = self.preference;
    info.isSoldOut = self.isSoldOut;
    info.preferHistory = self.preferHistory;
    info.otherPrefer = self.otherPrefer;
    info.quanpin = self.quanpin;
    info.jianpin = self.jianpin;
    info.orderNum = self.orderNum;
    info.orderID = self.orderID;
    info.isInput = self.isInput;
    
    for (PreferInfo* preferInfo in self.preferList) {
        [info.preferList addObject:[preferInfo copy]];
    }
    
    return info;
}

-(void)copy:(DishesInfo *)info {
    
    self.dishesID = info.dishesID;
    self.name = info.name;
    self.category = info.category;
    self.price = info.price;
    self.vipPrice = info.vipPrice;
    self.islimit = info.islimit;
    self.preference = info.preference;
    self.isSoldOut = info.isSoldOut;
    self.preferHistory = info.preferHistory;
    self.otherPrefer = info.otherPrefer;
    self.quanpin = info.quanpin;
    self.jianpin = info.jianpin;
    
    for (PreferInfo* preferInfo in info.preferList) {
        [self.preferList addObject:[preferInfo copy]];
    }
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.orderNum = [jsonDic objectForKey:@"count"];
    self.name = [jsonDic objectForKey:@"menuname"];
    self.price = [[jsonDic objectForKey:@"menuprice"] stringValue];
    self.vipPrice = [[jsonDic objectForKey:@"vipprice"] stringValue];
    self.islimit = [jsonDic objectForKey:@"islimit"];
    self.dishesID = [[jsonDic objectForKey:@"menuid"] stringValue];
    self.isSoldOut = [[jsonDic objectForKey:@"soldout"] intValue] == 1;
    self.preferHistory = [jsonDic objectForKey:@"preference"];
    self.otherPrefer = [jsonDic objectForKey:@"other_prefer"];
    if ([self.dishesID isEqualToString:@"0"]) {
        self.isInput = YES;
    }
    
    AppDelegate* appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    DishesInfo* findDishesInfo = [appDelegate getDishesInfo:self.dishesID];//[appDelegate.dishesList objectForKey:self.dishesID];
    if (findDishesInfo != nil) {
        for (PreferInfo* preferInfo in findDishesInfo.preferList) {
            PreferInfo* info = [[PreferInfo alloc] init];
            info.preferID = preferInfo.preferID;
            info.name = ((PreferInfo*)[appDelegate.preferList objectForKey:[NSString stringWithFormat:@"%d",preferInfo.preferID]]).name;
            [self.preferList addObject:info];
        }
    }
    
    NSArray* preferArray = [jsonDic objectForKey:@"phids"];
    for (int j=0; j<preferArray.count; j++) {
        int preferId = [[preferArray objectAtIndex:j] intValue];
        [self setPreferCheck:preferId];
    }
}

@end
