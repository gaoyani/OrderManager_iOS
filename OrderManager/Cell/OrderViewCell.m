//
//  OrderViewCell.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/15.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderViewCell.h"
#import "Constants.h"
#import "Utils.h"

@implementation OrderViewCell {
    UIEdgeInsets edgeInsets;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(operateResult:)
     name:@"operateResult"
     object:nil];
    
    edgeInsets = UIEdgeInsetsMake(34, 15, 34, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(OrderInfo*)info {
    orderInfo = info;
    self.waimai.hidden = !info.isTakeOutOrder;
    if (info.type == OrderTypeOrder) {
        self.orderIDView.hidden = NO;
        self.orderID.text = info.content;
        self.orderName.text = [NSString stringWithFormat:@"%@%@",info.tableName, NSLocalizedString(@"order_food", nil)];
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        self.orderIDView.hidden = YES;
        CGRect frame = self.orderName.frame;
        frame.origin.y = 10;
        self.orderName.frame = frame;
        self.orderName.text = [NSString stringWithFormat:@"%@ : %@",info.tableName,info.content];
        [self setBackgroundColor:[UIColor colorWithRed:241/255.0f green:218/255.0f blue:215/255.0f alpha:1.0f]];
    }
    
    if (info.type == OrderTypeOrder &&
        (info.state == OrderStateNew || info.state == OrderStateAccept)) {
        self.deleteOrder.hidden = NO;
    } else {
        self.deleteOrder.hidden = YES;
    }
    
    //set states
    if (info.state == OrderStateNew) {
        self.acceptOrder.hidden = NO;
        self.acceptOrder.titleLabel.text = NSLocalizedString(@"accept", nil);
        [self.acceptOrder setBackgroundImage:[[UIImage imageNamed:@"btn_logout_up"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
        [self.acceptOrder setBackgroundImage:[[UIImage imageNamed:@"btn_logout_down"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
        
    } else if (info.state == OrderStateAccept) {
        if (info.type == OrderTypeCalling) {
            self.acceptOrder.hidden = NO;
            [self.acceptOrder setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
            [self.acceptOrder setBackgroundImage:[[UIImage imageNamed:@"btn_confirm_up"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
            [self.acceptOrder setBackgroundImage:[[UIImage imageNamed:@"btn_confirm_down"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
        } else {
            self.acceptOrder.hidden = YES;
            self.orderState.text = NSLocalizedString(@"order_accept", nil);
            [self.orderState setTextColor:[UIColor redColor]];
        }
    } 
}

- (IBAction)acceptClick:(id)sender {
    if (orderInfo.type == OrderTypeCalling) {
        if (orderInfo.state == OrderStateNew) {
            [orderInfo changeState:OrderStateAccept];
        } else {
            [orderInfo changeState:OrderStateFinish];
        }
    } else {
        [orderInfo changeState:OrderStateAccept];
    }
}

- (IBAction)deleteClick:(id)sender {
    
    NSString* deleteMessage = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"order_delete_message", nil),orderInfo.tableName,NSLocalizedString(@"order_delete_message_end",nil)];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"order_delete_title", nil) message:deleteMessage delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [orderInfo deleteOrder];
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

@end
