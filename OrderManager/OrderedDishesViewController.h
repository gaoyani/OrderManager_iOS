//
//  OrderDetailViewController.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/20.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"
#import "PreferChooseView.h"
#import "OrderUpdateView.h"

@interface OrderedDishesViewController: UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *takeOutInfoView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactNumber;
@property (weak, nonatomic) IBOutlet UILabel *contactAddress;
@property (weak, nonatomic) IBOutlet UILabel *sendType;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
@property (weak, nonatomic) IBOutlet UITableView *dishesTableView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIImageView *submitViewBG;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *submit;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property PreferChooseView *preferChooseView;
@property OrderUpdateView *orderUpdateView;

@property OrderInfo* orderInfo;
@property BOOL isNewOrder;

@end
