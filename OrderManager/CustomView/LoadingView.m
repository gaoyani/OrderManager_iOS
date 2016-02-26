//
//  LoadingView.m
//  lzyw
//
//  Created by 高亚妮 on 15/4/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(void)awakeFromNib {
    CGRect rx = [UIScreen mainScreen].bounds;
    
    int loadingBGW = 100;
    self.loadingBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadingBGW, loadingBGW)];
    self.loadingBG.center = CGPointMake(rx.size.width/2, rx.size.height/2-loadingBGW/2);
    [self.loadingBG setImage:[[UIImage imageNamed:@"loading_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)]];
    [self addSubview:self.loadingBG];
    
    int loadingImageW = 90;
    self.loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loadingImageW, loadingImageW)];
    self.loadingImage.center = CGPointMake(rx.size.width/2, rx.size.height/2-loadingBGW/2);
    [self.loadingImage setImage:[UIImage imageNamed:@"loading_00"]];
    [self addSubview:self.loadingImage];
    
    self.loadingLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    self.loadingLable.center = CGPointMake(rx.size.width/2, rx.size.height/2-loadingBGW/2);
    self.loadingLable.font = [UIFont systemFontOfSize:11.0f];
    self.loadingLable.textColor = [UIColor whiteColor];
    self.loadingLable.backgroundColor = [UIColor clearColor];
    self.loadingLable.text = @"正在加载...";
    [self addSubview:self.loadingLable];
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999999;
    [self.loadingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)showView {
    [self.loadingImage.layer removeAllAnimations];
    self.hidden = NO;
    [self.loadingImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)setLoadingText:(NSString*)text {
    self.loadingLable.text = text;
}

+(LoadingView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
