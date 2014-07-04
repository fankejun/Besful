//
//  YZYViewController.h
//  Frame
//
//  Created by yzy on 13-6-29.
//  Copyright (c) 2013年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseService.h"
#import "Define.h"
#define Screen_Width    [UIScreen mainScreen].bounds.size.width
#define Screen_Height   [UIScreen mainScreen].bounds.size.height
#define IsIOS7 [[[UIDevice currentDevice] systemVersion] hasPrefix:@"7."]
#define Is3_5inch Screen_Height==480.0?YES:NO
#define Is4_0inch Screen_Height==568.0?YES:NO


@interface BaseViewController : UIViewController<UITextFieldDelegate,ServiceDelegete,UIAlertViewDelegate,UIWebViewDelegate>
{
    int requestCount;
    UIImageView * bodyBGImageView;
    UIView * menuListView;
    BOOL isOperationViewOpen;
    NSMutableArray * requestArray;
}

@property(nonatomic,strong)UIView * loading_view;
@property(nonatomic,strong)UIImageView * act_view;


//应用程序从后台到前台
- (void)applicationWillEnterForeground:(UIApplication *)application;


//应用程序从前台到后台
- (void)applicationDidEnterBackground:(UIApplication *)application;


//收到通知
-(void)receiveNotification:(id)sender;

//图片处理
-(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size;

-(id)getAnSimpleObject:(Class)paramClass withFromDictionary:(NSDictionary*)paramDic;

-(void)navBtnClicked:(UIButton*)sender;

//延时加载处理
-(void) addLoadingView;

//删除加载视图
-(void) removeLoadingView;

-(void)initTopUI;

-(void)addOprationView;
-(void)removeOperationView;


@end
