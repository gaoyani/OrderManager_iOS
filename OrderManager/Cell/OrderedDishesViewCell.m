//
//  OrderedDishesViewCell.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/20.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderedDishesViewCell.h"
#import "PreferInfo.h"

@implementation OrderedDishesViewCell {
    OrderdDishesInfo* dishesInfo;
}

- (void)awakeFromNib {
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        
        NSMutableDictionary* userInfoDic = [[NSMutableDictionary alloc] init];
        [userInfoDic setValue:dishesInfo.dishesID forKey:@"id"];
        [userInfoDic setValue:[NSString stringWithFormat:@"%f",count] forKey:@"count"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dishesCountChanged" object:self userInfo:userInfoDic];
    };
    [self.stepper setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(OrderdDishesInfo*)info isVip:(BOOL)isVip isTakeOutOrder:(BOOL)isTakeOutOrder isConfirmOrder:(BOOL)isConfirmOrder{
    dishesInfo = info;
    
    self.dishesName.text = info.name;
    self.dishesPrice.text = [NSString stringWithFormat:@"¥%@", (([info.vipPrice intValue] == 0 || !isVip) ? info.price : info.vipPrice)];
    self.prefers.text = [self getPrefers];
    self.soldOut.hidden = !info.isSoldOut;
    
    if (isConfirmOrder) {
        self.stepper.maximum = [info.orderNum floatValue];
    } else {
        self.stepper.enabled = !isTakeOutOrder;
    }
    
    [self.stepper setValue:[info.orderNum intValue]];
}

-(NSString*)getPrefers {
    NSString* prefers = @"";
    for (PreferInfo* info in dishesInfo.preferList) {
        if (info.isChecked) {
            prefers = [prefers stringByAppendingString:info.name];
            prefers = [prefers stringByAppendingString:@" "];
        }
    }
    
    if (dishesInfo.otherPrefer != nil) {
        prefers = [prefers stringByAppendingString:dishesInfo.otherPrefer];
    }
    
    return prefers;
}

@end
