//
//  ConfirmOrderedDishesViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 16/2/22.
//  Copyright © 2016年 gaoyani. All rights reserved.
//

#import "ConfirmOrderedDishesViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "OrderInfo.h"
#import "Utils.h"
#import "OrderedDishesViewCell.h"

@interface ConfirmOrderedDishesViewController () {
    AppDelegate* appDelegate;
    NSMutableArray* orderList;
    OrderInfo* firstOrderInfo;
    int taskCount;
}

@end

@implementation ConfirmOrderedDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    orderList = (NSMutableArray*)[appDelegate.confirmOrderList objectForKey:self.tableID];
    firstOrderInfo = (OrderInfo*)[orderList objectAtIndex:0];
    self.navigationItem.title = firstOrderInfo.tableName;
    
    taskCount = 0;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(16, 17, 16, 4);
    [self.submitViewBG setImage:[[UIImage imageNamed:@"order_confirm_up"] resizableImageWithCapInsets:edgeInsets]];
    [self.submitViewBG setHighlightedImage:[[UIImage imageNamed:@"order_confirm_down"] resizableImageWithCapInsets:edgeInsets]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderedDishesViewCell" bundle:nil] forCellReuseIdentifier:@"OrderedDishesViewCell"];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
        
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:confirmEditEnableKey] boolValue])  {
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitClick)];
        [self.submitView addGestureRecognizer:singleTap];
    } else {
        self.submit.text = @"";
        self.tableView.allowsSelection = NO;
    }
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailResult:) name:@"getDetailResult" object:nil];
    for (OrderInfo* orderInfo in orderList) {
        [orderInfo getOrderedDishes];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishesCountChanged:) name:@"dishesCountChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadOrderResult:) name:@"uploadOrderResult" object:nil];
}

-(void)getDetailResult:(NSNotification *)notification {
    taskCount++;
    if (taskCount < orderList.count) {
        return;
    }
    
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.tableView reloadData];
        [self updatePrice];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

-(void)submitClick {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    for (OrderInfo* orderInfo in orderList) {
        [orderInfo uploadOrder];
    }
}

-(void)uploadOrderResult:(NSNotification *)notification {
    taskCount++;
    if (taskCount < orderList.count) {
        return;
    }
    
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return orderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((OrderInfo*)[orderList objectAtIndex:section]).dishesList.count;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor grayColor]];
    header.textLabel.font = [UIFont systemFontOfSize:13];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    return [NSString stringWithFormat:@"  订单号：%@", ((OrderInfo*)[orderList objectAtIndex:section]).content];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == orderList.count-1) {
        return 50;
    } else {
        return 0;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderedDishesViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"OrderedDishesViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    OrderInfo* orderInfo = [orderList objectAtIndex:indexPath.section];
    [cell setContent:[orderInfo.dishesList objectAtIndex:indexPath.row] isVip:orderInfo.isVip isTakeOutOrder:orderInfo.isTakeOutOrder isConfirmOrder:orderInfo.state == OrderStateConfirm];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell layoutIfNeeded];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OrderInfo* orderInfo = [orderList objectAtIndex:indexPath.section];
        ((OrderdDishesInfo*)[orderInfo.dishesList objectAtIndex:indexPath.row]).orderNum = 0;
        [self updatePrice];
        [tableView reloadData];
        // Delete the row from the data source.
//        [testTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]         withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"clear", nil);
}

-(void)dishesCountChanged:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    NSString* dishesID = [userInfoDic objectForKey:@"id"];
    NSString* count = [userInfoDic objectForKey:@"count"];
    for (OrderInfo* orderInfo in orderList) {
        [orderInfo findOrderedDishes:dishesID].orderNum = count;
    }

    [self updatePrice];
}

-(void)updatePrice {
    float total = 0;
    for (OrderInfo* orderInfo in orderList) {
        for (OrderdDishesInfo* info in orderInfo.dishesList) {
            float price = ((orderInfo.isVip && ![info.vipPrice intValue] == 0) ? [info.vipPrice floatValue] : [info.price floatValue])*[info.orderNum intValue];
            total += price;
        }
    }
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f",total];
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
