//
//  OrderdDishesInfo.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DishesInfo.h"

@interface OrderdDishesInfo : DishesInfo<NSCopying>

@property NSString* orderNum;
@property NSString* orderID;
@property BOOL isInput;

-(OrderdDishesInfo*)init;
-(void)parseJson:(NSDictionary*)jsonDic;

@end
