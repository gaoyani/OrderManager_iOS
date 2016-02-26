//
//  AddDishesViewCell.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "AddDishesViewCell.h"

@implementation AddDishesViewCell {
    DishesInfo* dishesInfo;
}

- (void)awakeFromNib {
    self.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        if (((int)count) != 0) {
            NSMutableDictionary* userInfoDic = [[NSMutableDictionary alloc] init];
            [userInfoDic setValue:dishesInfo.dishesID forKey:@"id"];
            [userInfoDic setValue:[NSString stringWithFormat:@"%f",count] forKey:@"count"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dishesCountChanged" object:self userInfo:userInfoDic];
        }
    };
    [self.stepper setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(DishesInfo*)info orderNumber:(int)orderNumber {
    dishesInfo = info;
    
    self.dishesName.text = info.name;
    self.price.text = [NSString stringWithFormat:@"¥%@", info.price];
    self.soldOut.hidden = !info.isSoldOut;
    
    self.stepper.value = orderNumber;
    self.stepper.enabled = !info.isSoldOut;
}

@end
