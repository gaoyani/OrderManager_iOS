//
//  PayPasswordView.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface OrderUpdateView : UIView<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *dlgView;
@property (weak, nonatomic) IBOutlet UIButton *tableChoose;
@property (weak, nonatomic) IBOutlet UIView *checkBoxView;
@property (weak, nonatomic) IBOutlet UIButton *addOrder;
@property (weak, nonatomic) IBOutlet UIButton *vipOrder;
@property (weak, nonatomic) IBOutlet UITextField *peopleNumber;
@property (weak, nonatomic) IBOutlet UITextView *orderRemark;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonOK;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

+(OrderUpdateView *)initView;

-(void)setInfo:(OrderInfo *)info tableList:(NSMutableArray*)list;
-(void)viewShow;

@end
