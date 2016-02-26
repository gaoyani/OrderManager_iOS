//
//  LoadingView.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/22.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
    CABasicAnimation* rotationAnimation;
}

@property UIImageView *loadingBG;
@property UIImageView *loadingImage;
@property UILabel *loadingLable;

-(void)setLoadingText:(NSString*)text;
-(void)showView;

+(LoadingView *)initView;

@end
