//
//  AppDelegate.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/10.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishesInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property NSMutableArray* unconfirmOrderList;
@property NSMutableDictionary* confirmOrderList;
@property NSMutableArray* confirmTableIDList;

@property NSTimer* orderUpdateTimer;
@property NSMutableArray* dishesList;
@property NSMutableDictionary* preferList;
@property NSMutableArray* categoryList;

-(DishesInfo*)getDishesInfo:(NSString*)dishesID;
-(int)searchPeopleNum:(NSString*)tableID;

@end

