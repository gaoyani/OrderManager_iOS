//
//  PayPasswordView.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderdDishesInfo.h"

@interface PreferChooseView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UIView *preferCheckView;
@property (weak, nonatomic) IBOutlet UIView *otherPreferView;
@property (weak, nonatomic) IBOutlet UITextView *preferInput;
@property (weak, nonatomic) IBOutlet UILabel *preferHistory;
@property (weak, nonatomic) IBOutlet UIButton *buttonOK;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preferCheckViewHeight;

+(PreferChooseView *)initView;

-(void)viewShow;
-(void)setDishesInfo:(OrderdDishesInfo *)info;

@end
