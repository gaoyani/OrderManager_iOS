//
//  OrderedDishesViewCell.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/20.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
#import "OrderdDishesInfo.h"

@interface OrderedDishesViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishesName;
@property (weak, nonatomic) IBOutlet UILabel *dishesPrice;
@property (weak, nonatomic) IBOutlet UIImageView *soldOut;
@property (weak, nonatomic) IBOutlet PKYStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *prefers;

-(void)setContent:(OrderdDishesInfo*)info isVip:(BOOL)isVip isTakeOutOrder:(BOOL)isTakeOutOrder isConfirmOrder:(BOOL)isConfirmOrder;

@end
