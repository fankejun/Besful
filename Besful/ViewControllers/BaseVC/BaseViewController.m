//
//  YZYViewController.m
//  Frame
//
//  Created by yzy on 13-6-29.
//  Copyright (c) 2013年 yzy. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "AboutBesfulViewController.h"
#import "ProdInfoViewController.h"
#import "NewActivityViewController.h"
#import "UserInformationViewController.h"
#import "ASIFormDataRequest.h"
#import "ZViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContainer.h>

@interface BaseViewController ()

@end

NSTimeInterval timeInterval = 0.3;

@implementation BaseViewController
@synthesize loading_view;
@synthesize act_view;


-(void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
    for (ASIHTTPRequest * elem in requestArray)
    {
        [elem clearDelegatesAndCancel];
        elem.delegate = nil;
    }
    [requestArray removeAllObjects];
    [menuListView setHidden:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [menuListView setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    requestArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//应用程序从后台到前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}
//应用程序从前台到后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}
//收到通知
-(void)receiveNotification:(id)sender
{
    
}


//图片处理
-(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
/**延时加载处理**/

-(void) addLoadingView
{
    
}

-(void) removeLoadingView
{
    
}
-(void)initTopUI
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //BG
    [bodyBGImageView removeFromSuperview];
    bodyBGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+20*IsIOS7, 320, Screen_Height-20)];
    [bodyBGImageView setUserInteractionEnabled:YES];
    [self.view addSubview:bodyBGImageView];
    if (IsIOS7)
    {
        UIView * statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [statusView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:statusView];
    }
    
    //back button and more button
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 44, 30)];
    [backBtn setContentMode:UIViewContentModeScaleToFill];
    [backBtn setImage:[UIImage imageNamed:@"back_btnBG_normal"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [backBtn setTag:BACK_BUTTON_TAG];
    [backBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:backBtn];
    
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(44, -1, 44, 35)];
    [moreBtn setContentMode:UIViewContentModeScaleToFill];
    [moreBtn setImage:[UIImage imageNamed:@"more_btnBG_normal"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"more_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [moreBtn setTag:MORE_BUTTON_TAG];
    [moreBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:moreBtn];
    //logo
    UIImage * image = [UIImage imageNamed:@"homePage_navBar"];
    UIImageView * logo=[[UIImageView alloc]initWithFrame:CGRectMake(88, 0, 320-88, 57)];
    
    logo.image=image;
//    [logo setContentMode:UIViewContentModeScaleToFill];
    [bodyBGImageView addSubview:logo];
    [self performSelectorOnMainThread:@selector(initMenuUI) withObject:nil waitUntilDone:NO];
}

#pragma mark -- rewrite leftButton method
-(void)navBtnClicked:(UIButton*)sender
{
    switch (sender.tag)
    {
        case BACK_BUTTON_TAG:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case MORE_BUTTON_TAG:
        {
            if (isOperationViewOpen==NO)
            {
                [self addOprationView];
            }
            else
            {
                [self removeOperationView];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)addOprationView
{
    [menuListView setHidden:NO];
    [self.view bringSubviewToFront:menuListView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:timeInterval];
    CGRect frame = menuListView.frame;
    frame.origin.x = 0;
    [menuListView setFrame:frame];
    [UIView commitAnimations];
    
    isOperationViewOpen = YES;
}

-(void)removeOperationView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:timeInterval];
    CGRect frame = menuListView.frame;
    frame.origin.x = -320;
    [menuListView setFrame:frame];
    [UIView commitAnimations];
    isOperationViewOpen = NO;
}

-(void)initMenuUI
{
    menuListView = [[UIView alloc] initWithFrame:CGRectMake(-320, 20*IsIOS7, 320, Screen_Height)];
    [menuListView setHidden:YES];
    UIView * alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, Screen_Height)];
    [alphaView setBackgroundColor:[UIColor blackColor]];
    [alphaView setAlpha:0.5];
    [menuListView addSubview:alphaView];
    
    UIImageView * optionBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 270, Screen_Height)];
    [optionBGView setImage:[UIImage imageNamed:@"operationBG"]];
    [optionBGView setUserInteractionEnabled:YES];
    [menuListView addSubview:optionBGView];
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(optionBGView.frame.origin.x+optionBGView.frame.size.width, optionBGView.frame.origin.y, 320-optionBGView.frame.size.width, optionBGView.frame.size.height)];
    [rightView setUserInteractionEnabled:YES];
    [rightView setAlpha:alphaView.alpha];
    [rightView setTag:REMOVE_OPRATION_VIEW_TAG];
    
    [rightView addGestureRecognizer:tapGesture];
    
    [menuListView addSubview:rightView];
    
    
    //menu items  & title
    CGFloat value = 190/255.0f;
    UIColor * textColor = [UIColor colorWithRed:value green:value blue:value alpha:1.0];
    //title
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, optionBGView.frame.size.width, 35)];
    [titleLabel setText:@"目录选项"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:textColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [optionBGView addSubview:titleLabel];
    
    UIImageView * whiteLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height, optionBGView.frame.size.width-40, 2)];
    [whiteLine setImage:[UIImage imageNamed:@"whiteLine"]];
    [optionBGView addSubview:whiteLine];
    
    UIImageView * blackLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, whiteLine.frame.origin.y+whiteLine.frame.size.height+50, optionBGView.frame.size.width-20, 2)];
    [blackLine1 setImage:[UIImage imageNamed:@"blackLine1"]];
    [optionBGView addSubview:blackLine1];
    
    NSArray * optionItems = [NSArray arrayWithObjects:@"My Besful",@"品牌介绍",@"产品信息",@"最新活动",@"QR Code扫描",@"分享", nil];
    
    for (int i=0; i<6; i++)
    {
        //cell button
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, blackLine1.frame.origin.y+blackLine1.frame.size.height+i*46, optionBGView.frame.size.width, 44)];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(appMenuDidselect:) forControlEvents:UIControlEventTouchUpInside];
        [optionBGView addSubview:btn];
        switch (i)
        {
            case 0:
            {
                [btn setTag:MYBESFUL_BUTTON_TAG];
            }
                break;
            case 1:
            {
                [btn setTag:BRANDINTRODUCTION_BUTTON_TAG];
            }
                break;
            case 2:
            {
                [btn setTag:PRODINFO_BUTTON_TAG];
            }
                break;
            case 3:
            {
                [btn setTag:NEWACTIVITY_BUTTON_TAG];
            }
                break;
            case 4:
            {
                [btn setTag:QRCODESCALE_BUTTON_TAG];
            }
                break;
            case 5:
            {
                [btn setTag:SHARE_BUTTON_TAG];
            }
                break;
                
            default:
                break;
        }
        
        //ball image
        UIImageView * whiteCircle = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
        [whiteCircle setImage:[UIImage imageNamed:[NSString stringWithFormat:@"whiteCircle%d",i+1]]];
        [whiteCircle setBackgroundColor:[UIColor clearColor]];
        [btn addSubview:whiteCircle];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
        [imageView setCenter:whiteCircle.center];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"optionItem%d",i+1]]];
        [btn addSubview:imageView];
        
        
        //option title
        UILabel * optionItem = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, optionBGView.frame.size.width-80, 44)];
        [optionItem setText:[optionItems objectAtIndex:i]];
        [optionItem setTextColor:textColor];
        [optionItem setTextAlignment:NSTextAlignmentLeft];
        [optionItem setBackgroundColor:[UIColor clearColor]];
        [optionItem setFont:[UIFont boldSystemFontOfSize:20]];
        [btn addSubview:optionItem];
        
        //black line
        UIImageView * blackLinexx = [[UIImageView alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y+btn.frame.size.height, blackLine1.frame.size.width, 2)];
        [blackLinexx setImage:[UIImage imageNamed:[NSString stringWithFormat:@"blackLine%d",i+1]]];
        [optionBGView addSubview:blackLinexx];
        
    }
    [self.view addSubview:menuListView];
}

-(void)gestureAction:(UIGestureRecognizer*)gesture
{
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
    {
        if (gesture.view.tag==REMOVE_OPRATION_VIEW_TAG)
        {
            [self removeOperationView];
        }
    }
    else if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        
    }
}
#pragma mark MenuListDelegate
-(void)rightAlphaViewTaped:(UIGestureRecognizer *)sender
{
    [self removeOperationView];
}



//左侧按钮点击事件
-(void) appMenuDidselect:(UIButton*)sender
{
    NSLog(@"appMenuDidselect...%d",sender.tag);
    //NSLog(@"self.navigationController.viewControllers.count=%d",self.navigationController.viewControllers.count);
    
    switch (sender.tag)
    {
        case MYBESFUL_BUTTON_TAG:
        {
            NSUserDefaults * defalut=[NSUserDefaults standardUserDefaults];
            if ([defalut boolForKey:@"isLogoIn"]==NO)
            {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else
            {
                UserInformationViewController * userInfoCtl=[[UserInformationViewController alloc]init];
                [self.navigationController pushViewController:userInfoCtl animated:YES];
            }
            break;
        }
        case BRANDINTRODUCTION_BUTTON_TAG:
        {
            AboutBesfulViewController * aboutVC=[[AboutBesfulViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        } 
        case PRODINFO_BUTTON_TAG:
        {
            ProdInfoViewController * prodInfoVC=[[ProdInfoViewController alloc] init];
            [self.navigationController pushViewController:prodInfoVC animated:YES];
            break;
        }
        case NEWACTIVITY_BUTTON_TAG:
        {
            NewActivityViewController * newActivityVC = [[NewActivityViewController alloc] init];
            [self.navigationController pushViewController:newActivityVC animated:YES];
            break;
        }
        case QRCODESCALE_BUTTON_TAG: //二维码
        {
            ZViewController * zViewCtl=[[ZViewController alloc]init];
            [self.navigationController pushViewController:zViewCtl animated:YES];
            break;
        }
        case SHARE_BUTTON_TAG:
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"分享内容:"
                                               defaultContent:@"来自besful"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"Besful"
                                                          url:@"http://www.besful-china.com"
                                                  description:@"我正在使用Besful App了解Besful的最新动态！"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareActionSheet:nil
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:nil
                              shareOptions: nil
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        if (state == SSResponseStateSuccess)
                                        {
                                            NSLog(@"分享成功");
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                        }
                                    }];

            break;
        }
            
        default:
            break;
    }
    [self removeOperationView];
}

-(id)getAnSimpleObject:(Class)paramClass withFromDictionary:(NSDictionary*)paramDic
{
    id instance = [[paramClass alloc] init];
    NSArray *keyAry =  [paramDic allKeys];
    for (NSString *key in keyAry)
    {
        [instance setValue:[paramDic objectForKey:key] forKey:[key uppercaseString]];
    }
    return instance;
}
- (NSArray *)getPropertyListByClass: (Class)class
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList(class, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertyArray;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ServiceDelegate
/**返回的数据,如果是采用ASII POST 请求
 *返回一个过滤了异常的XML
 *采用 系统库类 对解析xml
 **/
-(void)setupDataSourceOnASIIByArray:(NSArray*)objArra CloReqTag:(NSInteger) tag
{
    
}
-(void)setupDataSourceNull:(NSInteger)tag
{
    
}
/*
 *用于当前ClassName为空的情况
 */
-(void)setupDataSourceXML:( CXMLDocument *)objxml CloReqTag:(NSInteger) tag
{
    
}

/*
 *用于当前服务器返回了错误信息
 */
-(void)setupDataSourceErrorResponseBean:( ErrorResponseBean *)errorBean CloReqTag:(NSInteger) tag
{
    
}
/**
 *当请求网络失败后
 **/
-(void)requestFailed:(NSString*)responseErr tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName
{
    
}


@end
