//
//  AppDelegate.m
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "HomePageViewController.h"
#import <ShareSDK/ShareSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSUserDefaults * defalut=[NSUserDefaults standardUserDefaults];
    [defalut removeObjectForKey:@"userInfoMation"];
    [defalut setObject:NO forKey:@"isLogoIn"];
    HomePageViewController * homePageVC = [[HomePageViewController alloc] init];
    self.rootNV = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    self.window.rootViewController = self.rootNV;
    [self.window makeKeyAndVisible];
    
    //判断网络，目前没有打开。若需要判断，解开下面一行的注释就可以
//    [self dealWithNetWorkIssure];
    [self initializePlat];
    return YES;
}

- (void)initializePlat
{
    //添加ShareSDK的APP Key
    [ShareSDK registerApp:@"df297218db9"];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"1682644197"
                               appSecret:@"b8df0a3b3f5ea990686d5929aa91b6b4"
                             redirectUri:@"http://www.besful-china.com"];
    
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:@"wx2342e47160c43afe" wechatCls:[WXApi class]];
    
    //添加QQ应用
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
}


+(AppDelegate*)shareAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

-(void)dealWithNetWorkIssure
{
    Reachability *reachability = [Reachability reachabilityWithHostName:web_url];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
        {
            netWorkType = @"no";
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的手机未接入网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        case ReachableViaWWAN:// 使用3G网络
            netWorkType = @"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            netWorkType = @"wifi";
            break;
    }
    NSLog(@"netWorkType==%@",netWorkType);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
