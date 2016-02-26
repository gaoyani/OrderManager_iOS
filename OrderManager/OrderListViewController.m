//
//  StoreTableViewController.m
//  lzyw
//
//  Created by 高亚妮 on 15/3/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderListViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "OrderViewCell.h"
#import "ConfirmOrderTableViewCell.h"
#import "OrderedDishesViewController.h"
#import "ConfirmOrderedDishesViewController.h"

@interface OrderListViewController () {
    NSMutableArray* newOrderList;
    NSMutableDictionary* confirmOrderList;
    NSMutableArray* confirmTableIDList;
}

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newOrderList = [NSMutableArray array];
    confirmTableIDList = [NSMutableArray array];
    confirmOrderList = [[NSMutableDictionary alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.isConfirmList) {
        [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOrderTableViewCell"];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"OrderViewCell" bundle:nil] forCellReuseIdentifier:@"OrderViewCell"];
    }
    
    [self setExtraCellLineHidden];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
}

-(void)setNewOrderList:(NSMutableArray*)orders {
    [newOrderList removeAllObjects];
    for (OrderInfo* info in orders) {
        [newOrderList addObject:[info copy]];
    }
}

-(void)setConfirmOrderList:(NSMutableArray*)tableIDs orders:(NSMutableDictionary*)orders {
    [confirmTableIDList removeAllObjects];
    for (NSString* tableID in tableIDs) {
        [confirmTableIDList addObject:tableID];
    }
    
    [confirmOrderList removeAllObjects];
    [confirmOrderList setValuesForKeysWithDictionary:orders];
//    for (NSString* tableID in tableIDs) {
//        [confirmTableIDList addObject:tableID];
//    }
}

-(void)reloadData {
    [self.tableView reloadData];
    self.loadingView.hidden = YES;
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isConfirmList ? confirmTableIDList.count : newOrderList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isConfirmList) {
        ConfirmOrderTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"ConfirmOrderTableViewCell" forIndexPath:indexPath];
        [cell setContent: [((NSMutableArray*)[confirmOrderList valueForKey:[confirmTableIDList objectAtIndex:indexPath.row]]) objectAtIndex:0]];
        [self setCellCommon:cell];
        
        return cell;

    } else {
        OrderViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"OrderViewCell" forIndexPath:indexPath];
        cell.parentViewController = self;

        [cell setContent:[newOrderList objectAtIndex:indexPath.row]];
        [self setCellCommon:cell];
        
        return cell;
    }
}

-(void)setCellCommon:(UITableViewCell*)cell {
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isConfirmList) {
        ConfirmOrderedDishesViewController* viewController = [[ConfirmOrderedDishesViewController alloc] initWithNibName:@"ConfirmOrderedDishesViewController" bundle:nil];
        viewController.tableID = [confirmTableIDList objectAtIndex:indexPath.row];
        [self.parentNavigationController pushViewController:viewController animated:YES];
    } else {
        OrderInfo* orderInfo = [newOrderList objectAtIndex:indexPath.row];
        if (orderInfo.type == OrderTypeOrder && orderInfo.state != OrderStateNew) {
            OrderedDishesViewController* viewController = [[OrderedDishesViewController alloc] initWithNibName:@"OrderedDishesViewController" bundle:nil];
            
            viewController.isNewOrder = NO;
            viewController.orderInfo = [orderInfo copy];
            
            [self.parentNavigationController pushViewController:viewController animated:YES];
        }

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
