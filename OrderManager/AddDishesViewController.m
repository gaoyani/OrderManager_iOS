//
//  AddDishesViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/21.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "AddDishesViewController.h"
#import "AppDelegate.h"
#import "SyncMenuTask.h"
#import "Constants.h"
#import "Utils.h"
#import "AddDishesViewCell.h"
#import "OrderdDishesInfo.h"
#import "CategoryInfo.h"
#import "InputDishesView.h"

@interface AddDishesViewController () {
    SyncMenuTask* syncMenuTask;
    AppDelegate* appDelegate;
    NSMutableArray* searchDishesIDList;
    InputDishesView* inputDishesView;
    int categoryID;
}

@end

@implementation AddDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"menu", nil);
    self.navigationItem.rightBarButtonItem = [self inputDishesButton];
    [self.startSearch setImage:[Utils scaleToSize:[UIImage imageNamed:@"search_icon"] size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.dishesTableView.delegate = self;
    self.dishesTableView.dataSource = self;
    [self.dishesTableView registerNib:[UINib nibWithNibName:@"AddDishesViewCell" bundle:nil] forCellReuseIdentifier:@"AddDishesViewCell"];
    [self setExtraCellLineHidden];
    
    //ios8 解决分割线没有左对齐问题
    if ([self.categoryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.categoryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.categoryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.categoryTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([self.dishesTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.dishesTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.dishesTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.dishesTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(16, 17, 16, 4);
    [self.submitViewBG setImage:[[UIImage imageNamed:@"order_confirm_up"] resizableImageWithCapInsets:edgeInsets]];
    [self.submitViewBG setHighlightedImage:[[UIImage imageNamed:@"order_confirm_down"] resizableImageWithCapInsets:edgeInsets]];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitClick)];
    [self.submitView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncMenuResult:) name:@"syncMenuResult" object:nil];
    searchDishesIDList = [NSMutableArray array];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    syncMenuTask = [[SyncMenuTask alloc] init];
    [syncMenuTask syncMenu:appDelegate.dishesList];
    
    [self cancelSearchClick:nil];
    self.searchInput.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dishesCountChanged:) name:@"dishesCountChanged" object:nil];
    
    inputDishesView = [InputDishesView initView];
    inputDishesView.hidden = YES;
    [self.view addSubview:inputDishesView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addInputDishes:) name:@"addInputDishes" object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.categoryTableView setTableFooterView:view];
}

-(UIBarButtonItem*)inputDishesButton{
    UIImage *btnImage = [UIImage imageNamed:@"btn_input_dishes"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return plusItem;
}

-(void)rightBtnClick {
    [inputDishesView viewShow];
}

-(void)addInputDishes:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    OrderdDishesInfo* info = [[OrderdDishesInfo alloc] init];
	info.dishesID = @"0";
	info.name = [userInfoDic objectForKey:@"dishes_name"];
	info.price = [userInfoDic objectForKey:@"dishes_price"];
	info.isInput = true;
    [self.orderInfo.dishesList addObject:info];
    [self updateOrderInfo];
}

-(void)syncMenuResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        self.dishesTableView.hidden = NO;
        [self searchCategoryDishes:0];
        [self.dishesTableView reloadData];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.categoryTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self updateOrderInfo];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
        self.dishesTableView.hidden = YES;
    }
}

- (IBAction)searchInputChanged:(id)sender {
    if ([self.searchInput.text isEqualToString:@""]) {
        [self searchCategoryDishes:0];
    } else {
        [self searchDishesName:self.searchInput.text];
    }
    
    [self.dishesTableView reloadData];
}

- (IBAction)startSearchClick:(id)sender {
    [super.navigationController setNavigationBarHidden:YES animated:YES];
    self.searchView.hidden = NO;
    self.categoryView.hidden = YES;

    self.dishesViewTopConstraint.constant = self.searchView.frame.size.height;
    self.dishesViewLeftConstraint.constant = 0;
}

- (IBAction)cancelSearchClick:(id)sender {
    [super.navigationController setNavigationBarHidden:NO animated:YES];
    self.searchView.hidden = YES;
    self.categoryView.hidden = NO;
    self.categoryViewTopConstraint.constant = 0;
    self.dishesViewTopConstraint.constant = 0;
    self.dishesViewLeftConstraint.constant = self.categoryView.frame.size.width;
    
    [self searchCategoryDishes:0];
    [self.dishesTableView reloadData];
}

- (IBAction)reloadDataClick:(id)sender {
    [syncMenuTask syncMenu:appDelegate.dishesList];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.categoryTableView]) {
        return appDelegate.categoryList.count;
    } else {
        if (categoryID == 0) {
            return appDelegate.dishesList.count+1;
        } else {
            return searchDishesIDList.count == 0 ? 0 : searchDishesIDList.count+1;
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.categoryTableView]) {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.categoryTableView]) {
        NSString *reuseIdetify = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.showsReorderControl = YES;
        }
        
        //ios8 解决分割线没有左对齐问题
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.textLabel setNumberOfLines:0];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = ((CategoryInfo*)[appDelegate.categoryList objectAtIndex:indexPath.row]).name;

        return cell;

    } else {
        if ((categoryID == 0 && indexPath.row == appDelegate.dishesList.count) || (categoryID != 0 && indexPath.row == searchDishesIDList.count)) {
            UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
            if (!defaultCell) {
                defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
            }
            
            defaultCell.accessoryType = UITableViewCellAccessoryNone;
            
            return defaultCell;
            
        }
        
        AddDishesViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddDishesViewCell" forIndexPath:indexPath];
        
        //ios8 解决分割线没有左对齐问题
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if (categoryID == 0) {
            DishesInfo* dishesInfo = [appDelegate.dishesList objectAtIndex:indexPath.row];
            [cell setContent:dishesInfo orderNumber:[self getOrderNumber:dishesInfo.dishesID]];
        } else {
            NSString* dishesID = [searchDishesIDList objectAtIndex:indexPath.row];
            DishesInfo* dishesInfo = [appDelegate getDishesInfo:dishesID];
            [cell setContent:dishesInfo orderNumber:[self getOrderNumber:dishesID]];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        [cell layoutIfNeeded];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.categoryTableView]) {
        CategoryInfo* categoryInfo = [appDelegate.categoryList objectAtIndex:indexPath.row];
        [self searchCategoryDishes:categoryInfo.categoryID];
        [self.dishesTableView reloadData];
    }
}

-(void)searchCategoryDishes:(int)categoryId {
    [searchDishesIDList removeAllObjects];
    categoryID = categoryId;
    if (categoryID != 0) {
        for (DishesInfo* dishesInfo in appDelegate.dishesList) {
            if (dishesInfo.category == categoryID) {
                [searchDishesIDList addObject:dishesInfo.dishesID];
            }
        }

    }
//    if (categoryID == 0) {
//        for (NSString* dishesID in appDelegate.dishesList) {
//            [searchDishesIDList addObject:dishesID];
//        }
//    } else {
//        for (NSString* dishesID in appDelegate.dishesList) {
//            DishesInfo* dishesInfo = [appDelegate.dishesList objectForKey:dishesID];
//            if (dishesInfo.category == categoryID) {
//                [searchDishesIDList addObject:dishesID];
//            }
//        }
//    }
}

-(void)searchDishesName:(NSString*)searchText {
    [searchDishesIDList removeAllObjects];
    for (DishesInfo* dishesInfo in appDelegate.dishesList) {
//        DishesInfo* dishesInfo = [appDelegate.dishesList objectForKey:dishesID];
        if ([dishesInfo.name rangeOfString:[searchText lowercaseString]].length != 0 ||
            [dishesInfo.quanpin rangeOfString:[searchText lowercaseString]].length != 0 ||
            [dishesInfo.jianpin rangeOfString:[searchText lowercaseString]].length != 0) {
            [searchDishesIDList addObject:dishesInfo.dishesID];
        }
    }  
}

-(int)getOrderNumber:(NSString*)dishesID {
    for (OrderdDishesInfo* info in self.orderInfo.dishesList) {
        if ([info.dishesID isEqualToString:dishesID]) {
            return [info.orderNum intValue];
        }
    }
    
    return 0;
}

-(void)dishesCountChanged:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    NSString* dishesID = [userInfoDic objectForKey:@"id"];
    NSString* count = [userInfoDic objectForKey:@"count"];
    DishesInfo* dishesInfo = [appDelegate getDishesInfo:dishesID];
    OrderdDishesInfo* orderdDishesInfo = [self.orderInfo findOrderedDishes:dishesID];
    if (orderdDishesInfo == nil) {
        orderdDishesInfo = [[OrderdDishesInfo alloc] init];
        [orderdDishesInfo copy:dishesInfo];
        orderdDishesInfo.orderNum = count;
        [self.orderInfo.dishesList addObject:orderdDishesInfo];
    } else {
        orderdDishesInfo.orderNum = count;
    }
    
    [self updateOrderInfo];
}

-(void)updateOrderInfo {
    float total = 0;
    int orderNumber = 0;
    for (OrderdDishesInfo* info in self.orderInfo.dishesList) {
        float price = ((self.orderInfo.isVip && ![info.vipPrice isEqualToString:@"0"]) ? [info.vipPrice floatValue] : [info.price floatValue])*[info.orderNum intValue];
        total += price;
        orderNumber = orderNumber+[info.orderNum intValue];
    }
    
    self.totalPrice.text = [NSString stringWithFormat:@"¥%.2f",total];
    self.dishesNum.text = [NSString stringWithFormat:@"%d%@",orderNumber,NSLocalizedString(@"dishes_num", nil)];
}

-(void)submitClick {
    NSMutableDictionary* userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:self.orderInfo forKey:@"order_info"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:self userInfo:userInfoDic];
    [self.navigationController popViewControllerAnimated:YES];
    [super.navigationController setNavigationBarHidden:NO animated:YES];
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
