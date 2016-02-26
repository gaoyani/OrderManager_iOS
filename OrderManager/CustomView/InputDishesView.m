//
//  PayPasswordView.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "InputDishesView.h"
#import "Constants.h"
#import "Utils.h"

@implementation InputDishesView {
    CGFloat offset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    
    self.dishesName.delegate = self;
    self.dishesPrice.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
        
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.dlgView.frame;
            frame.origin.y = 100;
            self.dlgView.frame = frame;
        }];
    }

    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    offset = self.frame.size.height-((self.dishesPrice.frame.origin.y+self.dlgView.frame.origin.y)+self.dishesPrice.frame.size.height+216+50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.dlgView.frame;
            frame.origin.y = frame.origin.y+offset;
            self.dlgView.frame = frame;
        }];
    }
    
    return YES;
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
    if ([self.dishesName.text isEqualToString:@""] || [self.dishesPrice.text isEqualToString:@""]) {
        [Utils showMessage:NSLocalizedString(@"input_dishes_name_price", nil)];
    }
    
    NSMutableDictionary* userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setObject:self.dishesName.text forKey:@"dishes_name"];
    [userInfoDic setObject:self.dishesPrice.text forKey:@"dishes_price"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addInputDishes" object:self userInfo:userInfoDic];

    [self viewDisappear];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self viewDisappear];
}

-(void)viewDisappear {
    [self.dishesName resignFirstResponder];
    [self.dishesPrice resignFirstResponder];

    self.dishesName.text = @"";
    self.dishesPrice.text = @"";
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

+(InputDishesView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InputDishesView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
