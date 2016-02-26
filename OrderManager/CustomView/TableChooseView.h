//
//  PayPasswordView.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableChooseView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+(TableChooseView *)initView;

-(void)setInfo:(NSMutableArray*)list;
-(void)viewShow;

@end
