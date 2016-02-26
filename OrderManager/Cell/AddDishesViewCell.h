//
//  AddDishesViewCell.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
#import "DishesInfo.h"

@interface AddDishesViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dishesName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *soldOut;
@property (weak, nonatomic) IBOutlet PKYStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *prefer;

-(void)setContent:(DishesInfo*)info orderNumber:(int)orderNumber;
@end
