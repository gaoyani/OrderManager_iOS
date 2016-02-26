//
//  PreferInfo.h
//  OrderManager
//
//  Created by 高亚妮 on 15/10/14.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferInfo : NSObject<NSCopying>

@property int preferID;
@property NSString* name;
@property BOOL isChecked;

-(PreferInfo*)init;

@end
