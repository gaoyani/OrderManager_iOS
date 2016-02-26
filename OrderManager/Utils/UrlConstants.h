//
//  URLConstants.h
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const login_url;
extern NSString* const logout_url;
extern NSString* const server_url;

@interface UrlConstants : NSObject

+(NSString *)getLoginUrl;
+(NSString *)getLogoutUrl;
+(NSString *)getServerUrl;

@end
