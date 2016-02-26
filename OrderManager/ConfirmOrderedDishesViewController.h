//
//  ConfirmOrderedDishesViewController.h
//  OrderManager
//
//  Created by 高亚妮 on 16/2/22.
//  Copyright © 2016年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderedDishesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UIImageView *submitViewBG;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *submit;

@property NSString* tableID;

@end
