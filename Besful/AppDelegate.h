//
//  AppDelegate.h
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    NSString * netWorkType;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *rootNV;


+(AppDelegate*)shareAppDelegate;

@end
