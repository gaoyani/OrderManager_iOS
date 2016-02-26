//
//  AppDelegate.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/10.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "SyncMenuTask.h"
#import "CommonInfoTask.h"
#import "OrderInfo.h"

@interface AppDelegate () {
    SyncMenuTask* syncMenuTask;
    CommonInfoTask* commonInfoTask;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置返回按钮图片
    UIImage *backUP=[UIImage imageNamed:@"btn_return"];
    UIImage *backDown=[UIImage imageNamed:@"btn_return"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backUP resizableImageWithCapInsets:UIEdgeInsetsMake(0, backUP.size.width, 0, 0)]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backDown resizableImageWithCapInsets:UIEdgeInsetsMake(0, backUP.size.width, 0, 0)]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    //去掉返回按钮的标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000.f, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    //导航栏背景色及标题
    UIColor* bgColor = [UIColor colorWithRed:1.0f green:132/255.0 blue:57/255.0f alpha:1];
    if ([Utils getDeviceVersion] < 7.0) {
        [[UINavigationBar appearance] setTintColor:bgColor];
    } else {
        [[UINavigationBar appearance] setBarTintColor:bgColor];
        //        [[UINavigationBar appearance] setTranslucent:NO];
        if([Utils getDeviceVersion] > 8.0 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            [[UINavigationBar appearance] setTranslucent:NO];
        } else {
            [[UINavigationBar appearance] setBackgroundColor:bgColor];
        }
    }
    
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor whiteColor],NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20],NSFontAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navTitleArr];
    
    if ([Utils getDeviceVersion] >= 7.0) {
        [[UINavigationBar appearance] setTranslucent:NO];  //设置标题半透明
    }
    
    self.unconfirmOrderList = [NSMutableArray array];
    self.confirmOrderList = [[NSMutableDictionary alloc] init];
    self.confirmTableIDList = [NSMutableArray array];
    
    //syncMenu
    [[NSNotificationCenter defaultCenter] addObserver:self selector:nil name:@"" object:nil];
    self.dishesList = [NSMutableArray array];//[[NSMutableDictionary alloc] init];
    syncMenuTask = [[SyncMenuTask alloc] init];
    [syncMenuTask syncMenu:self.dishesList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:nil name:@"" object:nil];
    self.categoryList = [NSMutableArray array];
    self.preferList = [[NSMutableDictionary alloc] init];
    commonInfoTask = [[CommonInfoTask alloc] init];
    [commonInfoTask getInfo:self.categoryList preferList:self.preferList];
    
    return YES;
}

-(DishesInfo*)getDishesInfo:(NSString*)dishesID {
//    for (NSString* ID in self.dishesList) {
//        DishesInfo* info = [self.dishesList objectForKey:ID];
    for (DishesInfo* info in self.dishesList) {
        if ([info.dishesID isEqualToString:@"0"]) {
            if ([info.name isEqualToString:dishesID])
                return info;
        } else {
            if ([info.dishesID isEqualToString:dishesID])
                return info;
        }
    }
    
    return nil;
}

-(int)searchPeopleNum:(NSString*)tableID {
    if (![[self.confirmOrderList allKeys] containsObject:tableID]) {
        return 0;
    }
    
    for (OrderInfo* orderInfo in [self.confirmOrderList objectForKey:tableID]) {
        if (!orderInfo.isAddOrder && [orderInfo.tableId isEqualToString:tableID]) {
            return orderInfo.peopleNum;
        }
    }
    
    return 0;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if (self.orderUpdateTimer != nil) {
        [self.orderUpdateTimer invalidate];
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
