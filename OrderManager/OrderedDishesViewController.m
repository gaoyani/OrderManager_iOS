//
//  OrderDetailViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/20.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderedDishesViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "OrderedDishesViewCell.h"
#import "OrderdDishesInfo.h"
#import "AddDishesViewController.h"
#import "TableListTask.h"

@interface OrderedDishesViewController () {
    NSMutableArray* tableList;
    TableListTask* tableListTask;
}
@end

@implementation OrderedDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.orderInfo.tableName;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(16, 17, 16, 4);
    [self.submitViewBG setImage:[[UIImage imageNamed:@"order_confirm_up"] resizableImageWithCapInsets:edgeInsets]];
    [self.submitViewBG setHighlightedImage:[[UIImage imageNamed:@"order_confirm_down"] resizableImageWithCapInsets:edgeInsets]];
    
    self.dishesTableView.delegate = self;
    self.dishesTableView.dataSource = self;
    [self.dishesTableView registerNib:[UINib nibWithNibName:@"OrderedDishesViewCell" bundle:nil] forCellReuseIdentifier:@"OrderedDishesViewCell"];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.dishesTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dishesTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.dishesTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.dishesTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (self.isNewOrder) {
        [self.loadingView stopAnimating];
        self.navigationItem.rightBarButtonItem = [self addOrderButton];
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitClick)];
        [self.submitView addGestureRecognizer:singleTap];
        
        [self rightBtnClick];
    } else {
        
        if (self.orderInfo.state == OrderStateAccept) {
            self.navigationItem.rightBarButtonItem = [self addOrderButton];
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitClick)];
            [self.submitView addGestureRecognizer:singleTap];
        } else {
            self.submit.text = @"";
            self.dishesTableView.allowsSelection = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailResult:) name:@"getDetailResult" object:nil];
        [self.orderInfo getOrderedDishes];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishesCountChanged:) name:@"dishesCountChanged" object:nil];
    
    self.preferChooseView = [PreferChooseView initView];
    self.preferChooseView.hidden = YES;
    [self.view addSubview:self.preferChooseView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferSetResult) name:@"preferSetResult" object:nil];
    
    tableListTask = [[TableListTask alloc] init];
    tableList = [NSMutableArray array];
    self.orderUpdateView = [OrderUpdateView initView];
    self.orderUpdateView.hidden = YES;
    [self.view addSubview:self.orderUpdateView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allTableListResult:) name:@"allTableListResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderUpdateConfirm) name:@"orderUpdateConfirm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadOrderResult:) name:@"uploadOrderResult" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"updateInfo" object:nil];
}

-(UIBarButtonItem*)addOrderButton{
    UIImage *btnImage = [UIImage imageNamed:@"btn_plus"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return plusItem;
}

-(void)rightBtnClick {
    AddDishesViewController* viewController = [[AddDishesViewController alloc] initWithNibName:@"AddDishesViewController" bundle:nil];
    viewController.orderInfo = [self.orderInfo copy];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)submitClick {
    if ([self.orderInfo isOrderEmpty]) {
        [Utils showMessage:NSLocalizedString(@"order_empty", nil)];
        return;
    }
    
    if ([self.orderInfo hasSoldOutDishes]) {
        [Utils showMessage:NSLocalizedString(@"order_has_sold_out", nil)];
        return;
    }
    
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [tableListTask getTableList:self.orderInfo.tableId tableList:tableList];
}

-(void)allTableListResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.orderUpdateView setInfo:self.orderInfo tableList:tableList];
        [self.orderUpdateView viewShow];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

-(void)orderUpdateConfirm {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    if (self.isNewOrder) {
        [self.orderInfo addOrder];
    } else {
        [self.orderInfo uploadOrder];
    }
}

-(void)uploadOrderResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}


-(void)getDetailResult:(NSNotification *)notification {
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        if (self.orderInfo.isTakeOutOrder) {
            self.contactName.text = self.orderInfo.contactName;
            self.contactNumber.text = self.orderInfo.contactNumber;
            self.contactAddress.text = self.orderInfo.contactAddress;
            self.sendType.text = self.orderInfo.sendType;
            self.sendTime.text = self.orderInfo.sendTime;
            self.takeOutInfoView.hidden = NO;
        
            self.tableViewTopConstraint.constant = self.takeOutInfoView.frame.size.height;
        } else {
            self.tableViewTopConstraint.constant = 0.0f;
        }
    
        [self.dishesTableView reloadData];
        [self updatePrice];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

-(void)preferSetResult {
    [self.dishesTableView reloadData];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = self.orderInfo.dishesList.count;
    return count+1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.orderInfo.dishesList.count) {
        UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
        if (!defaultCell) {
            defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        }
        
        defaultCell.accessoryType = UITableViewCellAccessoryNone;
        
        return defaultCell;

    }
    
    OrderedDishesViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"OrderedDishesViewCell" forIndexPath:indexPath];
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setContent:[self.orderInfo.dishesList objectAtIndex:indexPath.row] isVip:self.orderInfo.isVip isTakeOutOrder:self.orderInfo.isTakeOutOrder isConfirmOrder:self.orderInfo.state == OrderStateAccept];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderdDishesInfo* dishesInfo = [self.orderInfo.dishesList objectAtIndex:indexPath.row];
    [self.preferChooseView setDishesInfo:dishesInfo];
    [self.preferChooseView viewShow];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)dishesCountChanged:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    NSString* dishesID = [userInfoDic objectForKey:@"id"];
    NSString* count = [userInfoDic objectForKey:@"count"];
    [self.orderInfo findOrderedDishes:dishesID].orderNum = count;
    [self updatePrice];
}

-(void)updatePrice {
    float total = 0;
    for (OrderdDishesInfo* info in self.orderInfo.dishesList) {
        float price = ((self.orderInfo.isVip && ![info.vipPrice intValue] == 0) ? [info.vipPrice floatValue] : [info.price floatValue])*[info.orderNum intValue];
        total += price;
    }
    
    self.price.text = [NSString stringWithFormat:@"¥%.2f",total];
}

-(void)updateInfo:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    OrderInfo* tempOrderInfo = [userInfoDic objectForKey:@"order_info"];
    
    for (OrderdDishesInfo* info in tempOrderInfo.dishesList) {
        if (info.isInput) {
            [self.orderInfo.dishesList addObject:info];
        } else {
            OrderdDishesInfo* dishesInfo = [self.orderInfo findOrderedDishes:info.dishesID];
            if (dishesInfo == nil) {
                [self.orderInfo.dishesList addObject:info];
            } else {
                dishesInfo.orderNum = info.orderNum;
            }
        }
    }
    
    [self.dishesTableView reloadData];
    [self updatePrice];
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
