//
//  ConfirmOrderTableViewCell.m
//  OrderManager
//
//  Created by 高亚妮 on 16/2/23.
//  Copyright © 2016年 gaoyani. All rights reserved.
//

#import "ConfirmOrderTableViewCell.h"
#import "OrderInfo.h"
#import "Constants.h"
#import "Utils.h"

@implementation ConfirmOrderTableViewCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(operateResult:)
     name:@"operateResult"
     object:nil];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(34, 15, 34, 15);
    [self.printAccount setBackgroundImage:[[UIImage imageNamed:@"btn_confirm_up"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    [self.printAccount setBackgroundImage:[[UIImage imageNamed:@"btn_confirm_down"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
}

-(void)setContent:(OrderInfo*)info {
    orderInfo = info;
    
    self.orderName.text = [NSString stringWithFormat:@"%@%@",info.tableName, NSLocalizedString(@"order_food", nil)];
    self.printAccount.hidden = NO;
}

- (IBAction)printAccountClick:(id)sender {
    [orderInfo printAccount];
}

-(void)operateResult:(NSNotification*)notification {
    NSMutableDictionary* resultDic = (NSMutableDictionary*)notification.userInfo;
    int orderID = [[resultDic objectForKey:@"order_id"] intValue];
    if (orderID == orderInfo.orderID) {
        BOOL isSucceed = [[resultDic objectForKey:succeed] boolValue];
        if (isSucceed) {
            //            [self.parentViewController reloadData];
        } else {
            [Utils showMessage:[resultDic objectForKey:errorMessage]];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
