//
//  PayPasswordView.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/12.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "TableChooseView.h"
#import "Constants.h"
#import "Utils.h"
#import "TableInfo.h"

@implementation TableChooseView {
    NSMutableArray* tableList;
    int selTableIndex;
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
    
    //ios8 解决分割线没有左对齐问题
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundClick)];
    [self.bgView addGestureRecognizer:singleTap];
}

-(void)setInfo:(NSMutableArray*)list {
    tableList = list;
    [self.tableView reloadData];
}

-(void)viewShow {
    self.hidden = NO;
    self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformIdentity;
        self.dlgView.alpha = 1.0f;
    }];
}

-(void)viewDisappear {
    [UIView animateWithDuration:0.2 animations:^{
        self.dlgView.transform = CGAffineTransformMakeScale(0.97, 0.97);
        self.dlgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)backgroundClick {
    [self viewDisappear];
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
    NSMutableDictionary* userInfoDic = [[NSMutableDictionary alloc] init];
    [userInfoDic setValue:[NSNumber numberWithInt:selTableIndex] forKey:@"sel_index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tableChooseResult" object:self userInfo:userInfoDic];
    [self viewDisappear];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


+(TableChooseView *)initView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TableChooseView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
