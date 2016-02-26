//
//  DishesInfo.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishesInfo : NSObject<NSCopying>

@property NSString* dishesID;
@property NSString* name;
@property int category;
@property NSString* price;
@property NSString* vipPrice;
@property NSString* islimit;
@property int preference;
@property BOOL isSoldOut;
@property NSMutableArray* preferList;
@property NSString* preferHistory;
@property NSString* otherPrefer;

@property NSString* quanpin; //ping yin
@property NSString* jianpin; //jian pin yin

-(DishesInfo*)init;
-(void)setPreferCheck:(int)ID;
-(void)parseJson:(NSDictionary*)jsonDic;


@end
