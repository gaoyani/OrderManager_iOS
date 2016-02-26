//
//  ViewController.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/10.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userNameBG;
@property (weak, nonatomic) IBOutlet UIImageView *passwordBG;
@property (weak, nonatomic) IBOutlet UIImageView *serverBG;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *server;
@property (weak, nonatomic) IBOutlet UIButton *keepScreenOn;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

