//
//  PayPasswordView.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "PreferChooseView.h"
#import "Constants.h"
#import "Utils.h"
#import "PreferInfo.h"
#import "AppDelegate.h"

@implementation PreferChooseView {
    OrderdDishesInfo* dishesInfo;
    CGFloat offset;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.dlgView.layer.cornerRadius = 8;
    self.dlgView.layer.masksToBounds = YES;
    self.dlgView.layer.borderWidth = 2;
    self.dlgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIEdgeInsets edgeInsetsMake = UIEdgeInsetsMake(4, 20, 4, 20);
    [self.buttonOK setBackgroundImage:[[UIImage imageNamed:@"btn_login_up"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateNormal];
    [self.buttonOK setBackgroundImage:[[UIImage imageNamed:@"btn_login_down"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateHighlighted];
    [self.buttonCancel setBackgroundImage:[[UIImage imageNamed:@"btn_login_up"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateNormal];
    [self.buttonCancel setBackgroundImage:[[UIImage imageNamed:@"btn_login_down"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateHighlighted];
    
    self.preferInput.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.preferInput.layer.borderWidth = 1.0f;
    self.preferInput.layer.cornerRadius = 3.0f;
    
    self.preferInput.delegate = self;
}

-(void)setDishesInfo:(OrderdDishesInfo *)info {
    dishesInfo = info;
    self.preferHistory.text = dishesInfo.preferHistory;
    [self addPreferCheckBox];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if (offset <= 0) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.dlgView.frame;
                frame.origin.y = 100;
                self.dlgView.frame = frame;
            }];
        }
        
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    offset = self.frame.size.height-((self.otherPreferView.frame.origin.y+self.dlgView.frame.origin.y)+self.preferInput.frame.size.height+216+50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.dlgView.frame;
            frame.origin.y = frame.origin.y+offset;
            self.dlgView.frame = frame;
        }];
     }
    
    return YES;
}

-(void)addPreferCheckBox {
    for(UIView *view in [self.preferCheckView subviews]) {
        [view removeFromSuperview];
    }
    
    int row = dishesInfo.preferList.count%2 == 0 ? dishesInfo.preferList.count/2 :dishesInfo.preferList.count/2+1;
    _preferCheckViewHeight.constant = row*30+(row-1)*5;
    
    
    for (int i=0; i<dishesInfo.preferList.count; i++) {
        PreferInfo* info = [dishesInfo.preferList objectAtIndex:i];
        PreferInfo* preferInfo = [((AppDelegate*)[UIApplication sharedApplication].delegate).preferList objectForKey:[NSString stringWithFormat:@"%d",info.preferID]];
        CGRect frame = CGRectMake((i%2)*80,30*(i/2),70,30);
        UIButton* checkbox=[[UIButton alloc]initWithFrame:frame];
        
        [self.preferCheckView addSubview:checkbox];
        [checkbox setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
        [checkbox setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateSelected];
        [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [checkbox setValue:preferInfo forKey:@"info"];
        [checkbox setTag:i];
        
        [checkbox setBackgroundColor:[UIColor clearColor]];
        checkbox.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        [checkbox setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [checkbox setTitle:preferInfo.name forState:UIControlStateNormal];
        checkbox.selected = preferInfo.isChecked;
    }
}

-(void)checkboxClick:(UIButton*)checkBox {
    checkBox.selected = !checkBox.selected;
   
}

-(void)viewShow {
    self.hidden = NO;
    self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformIdentity;
        self.dlgView.alpha = 1.0f;
    }];
}

- (IBAction)buttonOKClick:(id)sender {
    for (UIButton* checkBox in self.preferCheckView.subviews) {
        PreferInfo* preferInfo = [dishesInfo.preferList objectAtIndex:checkBox.tag];
        preferInfo.isChecked = checkBox.selected;
    }
    dishesInfo.otherPrefer = self.preferInput.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"preferSetResult" object:self];
    [self viewDisappear];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self viewDisappear];
}

-(void)viewDisappear {
    self.preferInput.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+(PreferChooseView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PreferChooseView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
