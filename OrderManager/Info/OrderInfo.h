//
//  OrderInfo.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderdDishesInfo.h"
#import "NetConnection.h"

enum OrderState {
    OrderStateNew,
    OrderStateAccept,
    OrderStateConfirm,
    OrderStateFinish
};

enum OrderType {
    OrderTypeNone,
    OrderTypeOrder,
    OrderTypeCalling
};

enum TaskType {
    TaskTypeDelete,
    TaskTypeChangeState,
    TaskTypeGetOrderedDishes,
    TaskTypeUploadOrder,
    TaskTypeAddOrder,
    TaskTypePrintAccount
};

@interface OrderInfo : NSObject<NSCopying>

@property int orderID;
@property NSString* tableId;
@property NSString* tableName;
@property NSString* content;
@property NSString* notes;
@property enum OrderState state;
@property enum OrderType type;
@property int peopleNum;
@property BOOL isVip;
@property NSString* waiterId;
@property BOOL isAddOrder;
@property BOOL isTakeOutOrder;

@property NSString* contactName;
@property NSString* contactNumber;
@property NSString* contactAddress;
@property NSString* sendType;
@property NSString* sendTime;

@property NSMutableArray* dishesList;

-(OrderInfo*)init;
-(int)getDishesNum;
-(BOOL)isOrderEmpty;
-(BOOL)hasSoldOutDishes;
-(OrderdDishesInfo*)findOrderedDishes:(NSString*)dishesId;
-(void)parseJson:(NSDictionary*)jsonDic;

-(void)deleteOrder;
-(void)changeState:(enum OrderState)orderState;
-(void)printAccount;
-(void)getOrderedDishes;
-(void)uploadOrder;
-(void)addOrder;

@end
