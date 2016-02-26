//
//  DishesInfo.m
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import "DishesInfo.h"
#import "PreferInfo.h"

@implementation DishesInfo

-(DishesInfo*)init {
    self = [super init];
    if (self) {
        self.preferList = [NSMutableArray array];
        self.vipPrice = @"0";
        self.islimit = @"0";
    }
    
    return self;
}

-(void)setPreferCheck:(int)ID {
    for (PreferInfo* info in self.preferList) {
        if (info.preferID == ID) {
            info.isChecked = YES;
        }
    }
}

-(id)copyWithZone:(NSZone *)zone {
    DishesInfo* info = [[DishesInfo allocWithZone:zone] init];
    
    info.dishesID = self.dishesID;
    info.name = self.name;
    info.category = self.category;
    info.price = self.price;
    info.vipPrice = self.vipPrice;
    info.islimit = self.islimit;
    info.preference = self.preference;
    info.isSoldOut = self.isSoldOut;
    info.preferHistory = self.preferHistory;
    info.otherPrefer = self.otherPrefer;
    info.quanpin = self.quanpin;
    info.jianpin = self.jianpin;
    
    for (PreferInfo* preferInfo in self.preferList) {
        [info.preferList addObject:[preferInfo copy]];
    }
    
    return info;
}

-(void)parseJson:(NSDictionary*)jsonDic {
    self.dishesID = [[jsonDic objectForKey:@"menuid"] stringValue];
    self.name = [jsonDic objectForKey:@"menuname"];
    self.price = [jsonDic objectForKey:@"menuprice"];
    self.category = [[jsonDic objectForKey:@"groupid"] intValue];
    self.isSoldOut = ([[jsonDic objectForKey:@"soldout"] intValue] == 0) ? NO : YES;
    self.vipPrice = [jsonDic objectForKey:@"vipprice"];
    self.islimit = [jsonDic objectForKey:@"islimit"];
    
    NSMutableString *ms = [[NSMutableString alloc] initWithString:self.name];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
    self.jianpin = [self getFirstLetter:ms];
    self.quanpin = [ms stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@  %@", self.quanpin, self.jianpin);
    
    NSArray* preferArray = [jsonDic objectForKey:@"phids"];

    for (id prefer in preferArray) {
        PreferInfo* preferInfo = [[PreferInfo alloc] init];
        preferInfo.preferID = [prefer intValue];
        [self.preferList addObject:preferInfo];
    }
}

-(NSString*)getFirstLetter:(NSString*)pingyin {
    NSString* result = @"";
    NSArray *firstSplit = [pingyin componentsSeparatedByString:@" "];
    for (NSString* s in firstSplit) {
        if (s.length > 1) {
            result = [result stringByAppendingString:[s substringToIndex:1]];
        }
    }
    
    return result;
}

@end
