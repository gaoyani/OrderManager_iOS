//
//  OrderViewCell.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/15.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "OrderListViewController.h"

@interface OrderViewCell : UITableViewCell {
    OrderInfo* orderInfo;
}

@property (weak, nonatomic) IBOutlet UIView *orderIDView;
@property (weak, nonatomic) IBOutlet UILabel *orderID;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UIImageView *waimai;
@property (weak, nonatomic) IBOutlet UIButton *acceptOrder;
@property (weak, nonatomic) IBOutlet UIButton *deleteOrder;
@property (weak, nonatomic) IBOutlet UILabel *orderState;

@property OrderListViewController* parentViewController;

-(void)setContent:(OrderInfo*)orderInfo;
@end
