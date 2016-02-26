//
//  StoreTableViewController.h
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property UINavigationController* parentNavigationController;
@property BOOL isConfirmList;

-(void)setNewOrderList:(NSMutableArray*)orders;
-(void)setConfirmOrderList:(NSMutableArray*)tableIDs orders:(NSMutableDictionary*)orders;
-(void)reloadData;

@end
