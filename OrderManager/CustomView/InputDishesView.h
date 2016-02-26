//
//  PayPasswordView.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputDishesView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UITextField *dishesName;
@property (weak, nonatomic) IBOutlet UITextField *dishesPrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonOK;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

+(InputDishesView *)initView;

-(void)viewShow;

@end
