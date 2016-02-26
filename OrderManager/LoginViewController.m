//
//  ViewController.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/10.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "LoginTask.h"
#import "Utils.h"
#import "MainViewController.h"
#import "OrderViewController.h"

@interface LoginViewController () {
    LoginTask* task;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* textBG  = [[UIImage imageNamed:@"text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    self.userNameBG.image = textBG;
    self.passwordBG.image = textBG;
    self.serverBG.image = textBG;
    
    [self.login setBackgroundImage:[[UIImage imageNamed:@"btn_login_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 20, 4, 20)] forState:UIControlStateNormal];
    [self.login setBackgroundImage:[[UIImage imageNamed:@"btn_login_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 20, 4, 20)] forState:UIControlStateHighlighted];
    
    self.keepScreenOn.selected = [[NSUserDefaults standardUserDefaults] boolForKey:keepScreenOnKey];
    [self setKeepScreenOn];
    
    self.loadingView.hidden = YES;
    
    self.userName.text = [[NSUserDefaults standardUserDefaults] valueForKey:userNameKey];
    self.password.text = [[NSUserDefaults standardUserDefaults] valueForKey:passwordKey];
    NSString* serverStr = [[NSUserDefaults standardUserDefaults] valueForKey:serverKey];
    if (serverStr != nil) {
        self.server.text = [[NSUserDefaults standardUserDefaults] valueForKey:serverKey];
    }
    
    self.userName.delegate = self;
    self.password.delegate = self;
    self.server.delegate = self;
    
    task = [[LoginTask alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loginResult:)
     name:@"loginResult"
     object:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offset = self.view.frame.size.height-(self.keepScreenOn.frame.origin.y+self.keepScreenOn.frame.size.height+216+50);
    
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
//            CGRect frame = self.bgView.frame;
//            frame.origin.y = offset;
//            self.bgView.frame = frame;
            self.bgView.transform = CGAffineTransformMakeTranslation(0, offset);
        }];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
    
    return YES;
}

- (IBAction)keepScreenOnClick:(id)sender {
    self.keepScreenOn.selected = !self.keepScreenOn.selected;
    if (self.keepScreenOn.selected) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    [self setKeepScreenOn];
}

-(void)setKeepScreenOn {
    if (self.keepScreenOn.selected) {
        [self.keepScreenOn setImage:[UIImage imageNamed:@"login_checked.png"]forState:UIControlStateNormal];
    } else {
        [self.keepScreenOn setImage:[UIImage imageNamed:@"login_checkbox.png"]forState:UIControlStateNormal];
    }
}

- (IBAction)loginClick:(id)sender {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    [[NSUserDefaults standardUserDefaults]  setValue:self.userName.text forKey:userNameKey];
    [[NSUserDefaults standardUserDefaults]  setValue:self.password.text forKey:passwordKey];
    [[NSUserDefaults standardUserDefaults]  setValue:self.server.text forKey:serverKey];
    [[NSUserDefaults standardUserDefaults]  setBool:self.keepScreenOn.selected forKey:keepScreenOnKey];

    [task login:self.userName.text password:self.password.text];
}

-(void)loginResult:(NSNotification *)notification {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
    
    NSDictionary* userInfoDic = notification.userInfo;
    if ([[userInfoDic objectForKey:succeed] boolValue]) {
        [Utils showMessage:NSLocalizedString(@"login_success", nil)];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainViewController* viewController = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        [Utils showMessage:[userInfoDic objectForKey:errorMessage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
