//
//  URLConstants.m
//  lzyw
//
//  Created by 高亚妮 on 15/6/17.
//  Copyright (c) 2015年 huiwei. All rights reserved.
//

#import "UrlConstants.h"
#import "Constants.h"

NSString* const login_url = @"/ordering/api/employee/login.php";
NSString* const logout_url = @"/ordering/api/employee/logout.php";
NSString* const server_url = @"/ordering/api/employee/services.php";

@implementation UrlConstants

+(NSString *)getLoginUrl {
    return [NSString stringWithFormat:@"http://%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:serverKey],login_url];
}

+(NSString *)getLogoutUrl {
    return [NSString stringWithFormat:@"http://%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:serverKey],logout_url];
}

+(NSString *)getServerUrl {
    return [NSString stringWithFormat:@"http://%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:serverKey],server_url];
}



@end
