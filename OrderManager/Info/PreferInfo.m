//
//  PreferInfo.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "PreferInfo.h"

@implementation PreferInfo

-(PreferInfo*)init {
    self = [super init];
    if (self) {
        self.isChecked = NO;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    PreferInfo* info = [[PreferInfo allocWithZone:zone] init];
    
    info.preferID = self.preferID;
    info.name = self.name;
    info.isChecked = self.isChecked;
    
    return info;
}

@end
