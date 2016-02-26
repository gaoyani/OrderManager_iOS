//
//  AddDishesViewController.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/21.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface AddDishesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearch;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *startSearch;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UITableView *dishesTableView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIImageView *submitViewBG;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *dishesNum;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIButton *reloadData;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dishesViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dishesViewTopConstraint;


@property OrderInfo* orderInfo;

@end
