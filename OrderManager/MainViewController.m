//
//  MainViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/13.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "MainViewController.h"
#import "OrderViewController.h"
#import "MoreInfoViewController.h"
#import "Utils.h"
#import "Constants.h"

@interface MainViewController () {
    NSMutableArray* menuArray;
    BOOL isMenuShow;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waitressID.text = [[NSUserDefaults standardUserDefaults] valueForKey:userNameKey];
    
    isMenuShow = NO;
    self.mainMenu.dataSource = self;
    self.mainMenu.delegate = self;
    [self.mainMenu setScrollEnabled:NO];
    [self setExtraCellLineHidden];
    
    leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainMenuClick) name:@"mainMenuClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
}

-(void)setExtraCellLineHidden {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.mainMenu setTableFooterView:view];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft && isMenuShow) {
        [self viewMoveLeft];
    }
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    cell.textLabel.textColor = [UIColor whiteColor];
    int imageSize = 25;
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [Utils scaleToSize:[UIImage imageNamed:@"main_order"] size:CGSizeMake(imageSize, imageSize)];
            cell.textLabel.text = NSLocalizedString(@"menu_order", nil);
            break;
            
        case 1:
            cell.imageView.image = [Utils scaleToSize:[UIImage imageNamed:@"main_more"] size:CGSizeMake(imageSize, imageSize)];
            cell.textLabel.text = NSLocalizedString(@"menu_more_info", nil);
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.moreInfoContainer.hidden = YES;
            self.orderContainer.hidden = NO;
            [self viewMoveLeft];
            break;
            
        case 1:
            self.orderContainer.hidden = YES;
            self.moreInfoContainer.hidden = NO;
            [self viewMoveLeft];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)viewMoveLeft {
    
   // self.viewContainer.transform = CGAffineTransformMakeTranslation(250, 0);
    [UIView animateWithDuration:0.3 animations:^{
//        self.viewContainer.transform = CGAffineTransformIdentity;
//        self.viewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
        CGRect frame = self.viewContainer.frame;
        frame.origin.x = 0;
        self.viewContainer.frame = frame;
    }];
    
    isMenuShow = NO;
}

-(void)viewMoveRight {
//    self.viewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
//        self.viewContainer.transform = CGAffineTransformMakeTranslation(250, 0);
        CGRect frame = self.viewContainer.frame;
        frame.origin.x = 200;
        self.viewContainer.frame = frame;
    } completion:^(BOOL finished) {
    }];
    
    isMenuShow = YES;
}

-(void)mainMenuClick {
    if (isMenuShow) {
        [self viewMoveLeft];
    } else {
        [self viewMoveRight];
    }
}

-(void)logout {
    [self dismissViewControllerAnimated:YES completion:nil];
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
