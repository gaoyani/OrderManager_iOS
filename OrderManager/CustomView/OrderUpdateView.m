//
//  PayPasswordView.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "OrderUpdateView.h"
#import "Constants.h"
#import "Utils.h"
#import "TableInfo.h"
#import "AppDelegate.h"

@implementation OrderUpdateView {
    NSMutableArray* tableList;
    OrderInfo* orderInfo;
    int selTableIndex;
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
    offset = 0;
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIEdgeInsets edgeInsetsMake = UIEdgeInsetsMake(4, 20, 4, 20);
    [self.buttonOK setBackgroundImage:[[UIImage imageNamed:@"btn_login_up"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateNormal];
    [self.buttonOK setBackgroundImage:[[UIImage imageNamed:@"btn_login_down"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateHighlighted];
    [self.buttonCancel setBackgroundImage:[[UIImage imageNamed:@"btn_login_up"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateNormal];
    [self.buttonCancel setBackgroundImage:[[UIImage imageNamed:@"btn_login_down"] resizableImageWithCapInsets:edgeInsetsMake] forState:UIControlStateHighlighted];
    
    self.orderRemark.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.orderRemark.layer.borderWidth = 0.6f;
    self.orderRemark.layer.cornerRadius = 6.0f;
    self.orderRemark.delegate = self;
    self.peopleNumber.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)setInfo:(OrderInfo *)info tableList:(NSMutableArray*)list {
    orderInfo = info;
    tableList = list;
    
    [self.tableView reloadData];
    
    self.addOrder.selected = orderInfo.isAddOrder;
    self.vipOrder.selected = orderInfo.isVip;
    self.orderRemark.text = orderInfo.notes;
    
    for (int i=0; i<tableList.count; i++) {
        TableInfo* tableInfo = [tableList objectAtIndex:i];
        if ([tableInfo.tableID isEqualToString:orderInfo.tableId]) {
            [self.tableChoose setTitle:tableInfo.name forState:UIControlStateNormal];
            selTableIndex = i;
        }
    }
    
    if ([orderInfo.tableId isEqualToString:@"-1"]) {
        self.tableChoose.enabled = NO;
        [self.addOrder removeFromSuperview];
        [self.vipOrder removeFromSuperview];
    }
    
    [self updatePeopleNum];
}

-(void)updatePeopleNum {
    int tableSelIndex = self.tableView.indexPathForSelectedRow.row;
    int peopleNum = [((AppDelegate*)[UIApplication sharedApplication].delegate) searchPeopleNum:((TableInfo*)[tableList objectAtIndex:tableSelIndex]).tableID];
    [self.peopleNumber setText:[NSString stringWithFormat:@"%d",peopleNum]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self recoverDlg];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self upMoveDlgWhileEditing];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [self recoverDlg];
        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self upMoveDlgWhileEditing];
    return YES;
}

-(void)upMoveDlgWhileEditing {
    if (offset < 0) {
        return;
    }
    
    offset = self.frame.size.height-((self.orderRemark.frame.origin.y+self.dlgView.frame.origin.y)+self.orderRemark.frame.size.height+216+50);
    if (offset < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.dlgView.frame;
            frame.origin.y = frame.origin.y+offset;
            self.dlgView.frame = frame;
        }];
    }
}

-(void)recoverDlg {
    if (offset < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.dlgView.frame;
            frame.origin.y = 100;
            self.dlgView.frame = frame;
        }];
        
        offset = 0;
    }
}

-(void)viewShow {
    self.hidden = NO;
    self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformIdentity;
        self.dlgView.alpha = 1.0f;
    }];
}

- (IBAction)tableChooseClick:(id)sender {
    self.tableView.hidden = !self.tableView.isHidden;
}

- (IBAction)addDishesOrderClick:(id)sender {
    self.addOrder.selected = !self.addOrder.selected;
    [self updatePeopleNum];
}

- (IBAction)memberOrderClick:(id)sender {
    self.vipOrder.selected = !self.vipOrder.selected;
}

- (IBAction)buttonOKClick:(id)sender {
    [self viewDisappear];
    
    orderInfo.isAddOrder = self.addOrder.selected;
    orderInfo.isVip = self.vipOrder.selected;
    
    TableInfo* tableInfo = [tableList objectAtIndex:selTableIndex];
    orderInfo.tableId = tableInfo.tableID;
    orderInfo.tableName = tableInfo.name;
    orderInfo.notes = self.orderRemark.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderUpdateConfirm" object:nil];
}

- (IBAction)buttonCancelClick:(id)sender {
    [self viewDisappear];
}

-(void)viewDisappear {
    [self.peopleNumber resignFirstResponder];
    [self.orderRemark resignFirstResponder];
    [self recoverDlg];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark -tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdetify = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    //ios8 解决分割线没有左对齐问题
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor blackColor];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    TableInfo* tableInfo = [tableList objectAtIndex:indexPath.row];
    cell.textLabel.text = tableInfo.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selTableIndex = indexPath.row;
    TableInfo* tableInfo = [tableList objectAtIndex:indexPath.row];
    [self.tableChoose setTitle:tableInfo.name forState:UIControlStateNormal];
    
    self.tableView.hidden = YES;
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self updatePeopleNum];
}


+(OrderUpdateView *)initView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OrderUpdateView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
