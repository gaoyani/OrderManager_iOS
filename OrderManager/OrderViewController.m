//
//  OrderViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/13.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderListViewController.h"
#import "SyncOrderTask.h"
#import "AppDelegate.h"
#import "OrderedDishesViewController.h"
#import "TableChooseView.h"
#import "TableListTask.h"
#import "Constants.h"
#import "Utils.h"
#import "TableInfo.h"

@interface OrderViewController () {
    TableChooseView* tableChooseView;
    NSMutableArray* tableList;
    TableListTask* tableListTask;
    
    OrderListViewController* newOrderListViewController;
    OrderListViewController* confirmOrderListViewController;
    
    AppDelegate* appDelegate;
}

@end

@implementation OrderViewController

- (void)viewDidLoad {
    
    //[super viewDidLoad]放在self.dataSource = self; self.delegate = self;前会造成tab成disable状态
//    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"menu_order", nil);
    self.navigationItem.leftBarButtonItem = [self mainMenuButton];
    self.navigationItem.rightBarButtonItem = [self addOrderButton];
    
    self.dataSource = self;
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateOrderList:)
     name:@"updateOrderList"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(tableChooseResult:)
     name:@"tableChooseResult"
     object:nil];

    [self getOrdersTimer:nil];
    appDelegate = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    if (appDelegate.orderUpdateTimer == nil) {
        appDelegate.orderUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getOrdersTimer:) userInfo:nil repeats:YES];
    }
    
    [super viewDidLoad];
    
    tableChooseView = [TableChooseView initView];
    tableChooseView.hidden = YES;
    tableChooseView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tableChooseView];
    tableListTask = [[TableListTask alloc] init];
    tableList = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeTableListResult:) name:@"freeTableListResult" object:nil];
}

-(UIBarButtonItem*)mainMenuButton{
    UIImage *btnImage = [UIImage imageNamed:@"btn_more_menu"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mainMenuItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return mainMenuItem;
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

-(void)leftBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainMenuClick" object:self userInfo:nil];
}

-(void)rightBtnClick {
    [tableListTask getTableList:@"" tableList:tableList];
}

-(void)freeTableListResult:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        if (tableList.count == 0) {
            [Utils showMessage:NSLocalizedString(@"order_table_all_used", nil)];
        } else {
            [tableChooseView setInfo:tableList];
            [tableChooseView viewShow];
        }
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

-(void)tableChooseResult:(NSNotification*)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    int selIndex = [[userInfoDic objectForKey:@"sel_index"] intValue];
    TableInfo* tableInfo = [tableList objectAtIndex:selIndex];
    
    OrderedDishesViewController* viewController = [[OrderedDishesViewController alloc] initWithNibName:@"OrderedDishesViewController" bundle:nil];
    
    viewController.isNewOrder = YES;
    viewController.orderInfo = [[OrderInfo alloc] init];
    viewController.orderInfo.tableId = tableInfo.tableID;
    viewController.orderInfo.tableName = tableInfo.name;
    viewController.orderInfo.state = OrderStateAccept;
    viewController.orderInfo.notes = @"";
    viewController.orderInfo.isVip = NO;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)getOrdersTimer:(NSTimer *)timer {
    SyncOrderTask* task = [[SyncOrderTask alloc] init];
    [task getOrders];
}

-(void)updateOrderList:(NSNotification*)notification {
    [newOrderListViewController setNewOrderList:appDelegate.unconfirmOrderList];
    [newOrderListViewController reloadData];
    [confirmOrderListViewController setConfirmOrderList:appDelegate.confirmTableIDList orders:appDelegate.confirmOrderList];
    [confirmOrderListViewController reloadData];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    switch (index) {
        case 0:
            label.text = NSLocalizedString(@"order_tab_new", nil);
            break;
            
        case 1:
            label.text = NSLocalizedString(@"order_tab_confirm", nil);;
            break;
            
        default:
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        newOrderListViewController = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
        newOrderListViewController.parentNavigationController = self.navigationController;
        newOrderListViewController.isConfirmList = NO;
//        newOrderListViewController.orderList = newOrderList;
        return newOrderListViewController;
    } else {
        confirmOrderListViewController = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:nil];
        confirmOrderListViewController.parentNavigationController = self.navigationController;
        confirmOrderListViewController.isConfirmList = YES;
//        confirmOrderListViewController.orderList = confirmOrderList;
        return confirmOrderListViewController;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionTabWidth: {
            CGRect rx = [UIScreen mainScreen].bounds;
            return rx.size.width/2;
        }
            break;
        default:
            break;
    }
    
    return value;
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
