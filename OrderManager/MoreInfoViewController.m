//
//  SettingViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/13.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "LogoutTask.h"
#import "Constants.h"
#import "Utils.h"

@interface MoreInfoViewController () {
    LogoutTask* task;
}
@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    
    self.navigationItem.title = NSLocalizedString(@"menu_more_info", nil);
    self.navigationItem.leftBarButtonItem = [self mainMenuButton];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(33, 15, 34, 15);
    [self.logout setBackgroundImage:[[UIImage imageNamed:@"btn_logout_up"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
    [self.logout setBackgroundImage:[[UIImage imageNamed:@"btn_logout_down"] resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    self.appInfo.text = [NSString stringWithFormat:@"%@ v%@", appName,appVersion];
    
    task = [[LogoutTask alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutResult:) name:@"logoutResult" object:nil];
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

-(void)leftBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mainMenuClick" object:self userInfo:nil];
}

- (IBAction)logoutClick:(id)sender {
    [task logout];
}

-(void)logoutResult:(NSNotification *)notification {
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [Utils showMessage:NSLocalizedString(@"logout_success", nil)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:self userInfo:nil];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
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
