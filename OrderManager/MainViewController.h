//
//  MainViewController.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/13.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *waitressID;
@property (weak, nonatomic) IBOutlet UITableView *mainMenu;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *moreInfoContainer;
@property (weak, nonatomic) IBOutlet UIView *orderContainer;

@end
