//
//  ConfirmOrderTableViewCell.h
//  OrderManager
//
//  Created by 高亚妮 on 16/2/23.
//  Copyright © 2016年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfo;

@interface ConfirmOrderTableViewCell : UITableViewCell{
    OrderInfo* orderInfo;
}

@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UIButton *printAccount;

-(void)setContent:(OrderInfo*)orderInfo;


@end
