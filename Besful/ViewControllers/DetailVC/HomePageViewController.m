//
//  HomePageViewController.m
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "HomePageViewController.h"
#import "ProductDetailViewController.h"
#import "ProdInfoViewController.h"
#import "AboutBesfulViewController.h"
#import "LoginViewController.h"
#import "HotProdViewController.h"
#import "NewActivityViewController.h"
#import "UserInformationViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "GDataXMLNode.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContainer.h>
#import "ZViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    
}

-(void)initUI
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (IsIOS7)
    {
        UIView * statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [statusView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:statusView];
    }
    
    //home page BG
    UIImageView * homePageBGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20*IsIOS7, 320, Screen_Height)];
    homePageBGImageView.image = [UIImage imageNamed:@"homePage_BG"];
    [homePageBGImageView setUserInteractionEnabled:YES];
    
    UIImageView * logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIImage * image = [UIImage imageNamed:@"homePage_navBar"];
    [logoView setImage:image];
    [homePageBGImageView addSubview:logoView];
    
    CGFloat originY = 64.0;
    //line
    UIImage * lineImage = [UIImage imageNamed:@"homePage_BGLine"];
    UIImageView * BGLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 320, Screen_Height-2-100)];
    BGLineImageView.image = lineImage;
    [homePageBGImageView addSubview:BGLineImageView];
    
    //myBesful
    UIButton * myBesfulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myBesfulBtn setFrame:CGRectMake(217, originY, 95, 95)];
    [myBesfulBtn setImage:[UIImage imageNamed:@"myBesful_btnBG"] forState:UIControlStateNormal];
    [myBesfulBtn setImage:[UIImage imageNamed:@"myBesful_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [myBesfulBtn setTag:MYBESFUL_BUTTON_TAG];
    [myBesfulBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:myBesfulBtn];
    UILabel * myBesfulLabel = [[UILabel alloc] initWithFrame:CGRectMake(myBesfulBtn.frame.origin.x, myBesfulBtn.frame.origin.y+myBesfulBtn.frame.size.height, myBesfulBtn.frame.size.width, 20)];
    [myBesfulLabel setText:@"My Besful"];
    [myBesfulLabel setBackgroundColor:[UIColor clearColor]];
    [myBesfulLabel setTextAlignment:NSTextAlignmentCenter];
    [myBesfulLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:myBesfulLabel];
    myBesfulBtnFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [myBesfulBtnFrontImageView setImage:[UIImage imageNamed:@"myBesful"]];
    [myBesfulBtnFrontImageView setCenter:myBesfulBtn.center];
    [homePageBGImageView addSubview:myBesfulBtnFrontImageView];
    
    //brandIntroduction
    UIButton * brandIntroductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [brandIntroductionBtn setFrame:CGRectMake(110, 40+originY, 80, 80)];
    [brandIntroductionBtn setImage:[UIImage imageNamed:@"brandIntroduction_btnBG"] forState:UIControlStateNormal];
    [brandIntroductionBtn setImage:[UIImage imageNamed:@"brandIntroduction_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [brandIntroductionBtn setTag:BRANDINTRODUCTION_BUTTON_TAG];
    [brandIntroductionBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:brandIntroductionBtn];
    UILabel * brandIntroductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(brandIntroductionBtn.frame.origin.x, brandIntroductionBtn.frame.origin.y+brandIntroductionBtn.frame.size.height, brandIntroductionBtn.frame.size.width, 20)];
    [brandIntroductionLabel setText:@"品牌介绍"];
    [brandIntroductionLabel setBackgroundColor:[UIColor clearColor]];
    [brandIntroductionLabel setTextAlignment:NSTextAlignmentCenter];
    [brandIntroductionLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:brandIntroductionLabel];
    brandIntroductionFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [brandIntroductionFrontImageView setImage:[UIImage imageNamed:@"brandIntroduction"]];
    [brandIntroductionFrontImageView setCenter:brandIntroductionBtn.center];
    [homePageBGImageView addSubview:brandIntroductionFrontImageView];
    
    //prodInfo
    UIButton * prodInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prodInfoBtn setFrame:CGRectMake(10, 90+originY, 65, 65)];
    [prodInfoBtn setImage:[UIImage imageNamed:@"prodInfo_btnBG"] forState:UIControlStateNormal];
    [prodInfoBtn setImage:[UIImage imageNamed:@"prodInfo_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [prodInfoBtn setTag:PRODINFO_BUTTON_TAG];
    [prodInfoBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:prodInfoBtn];
    UILabel * prodInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(prodInfoBtn.frame.origin.x, prodInfoBtn.frame.origin.y+prodInfoBtn.frame.size.height, prodInfoBtn.frame.size.width, 20)];
    [prodInfoLabel setText:@"产品信息"];
    [prodInfoLabel setBackgroundColor:[UIColor clearColor]];
    [prodInfoLabel setTextAlignment:NSTextAlignmentCenter];
    [prodInfoLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:prodInfoLabel];
    prodInfoFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [prodInfoFrontImageView setImage:[UIImage imageNamed:@"prodInfo"]];
    [prodInfoFrontImageView setCenter:prodInfoBtn.center];
    [homePageBGImageView addSubview:prodInfoFrontImageView];
    
    //share
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(242, 115+originY, 70, 70)];
    [shareBtn setImage:[UIImage imageNamed:@"share_btnBG"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_btnB_highlighted"] forState:UIControlStateHighlighted];
    [shareBtn setTag:SHARE_BUTTON_TAG];
    [shareBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:shareBtn];
    UILabel * shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.frame.origin.x, shareBtn.frame.origin.y+shareBtn.frame.size.height, shareBtn.frame.size.width, 20)];
    [shareLabel setText:@"分享"];
    [shareLabel setBackgroundColor:[UIColor clearColor]];
    [shareLabel setTextAlignment:NSTextAlignmentCenter];
    [shareLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:shareLabel];
    shareFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [shareFrontImageView setImage:[UIImage imageNamed:@"share"]];
    [shareFrontImageView setCenter:shareBtn.center];
    [homePageBGImageView addSubview:shareFrontImageView];
    
    //QRCodeScale
    UIButton * QRCodeScaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [QRCodeScaleBtn setFrame:CGRectMake(130, 170+originY, 90, 90)];
    [QRCodeScaleBtn setImage:[UIImage imageNamed:@"QRCodeScale_btnBG"] forState:UIControlStateNormal];
    [QRCodeScaleBtn setImage:[UIImage imageNamed:@"QRCodeScale_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [QRCodeScaleBtn setTag:QRCODESCALE_BUTTON_TAG];
    [QRCodeScaleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:QRCodeScaleBtn];
    UILabel * QRCodeScaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(QRCodeScaleBtn.frame.origin.x, QRCodeScaleBtn.frame.origin.y+QRCodeScaleBtn.frame.size.height, QRCodeScaleBtn.frame.size.width, 20)];
    [QRCodeScaleLabel setText:@"QR Code扫描"];
    [QRCodeScaleLabel setBackgroundColor:[UIColor clearColor]];
    [QRCodeScaleLabel setTextAlignment:NSTextAlignmentCenter];
    [QRCodeScaleLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:QRCodeScaleLabel];
    QRCodeScaleFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [QRCodeScaleFrontImageView setImage:[UIImage imageNamed:@"QRCodeScale"]];
    [QRCodeScaleFrontImageView setCenter:CGPointMake(QRCodeScaleBtn.center.x-1, QRCodeScaleBtn.center.y)];
    [homePageBGImageView addSubview:QRCodeScaleFrontImageView];
    
    //newActivity
    UIButton * newActivityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newActivityBtn setFrame:CGRectMake(20, 200+originY, 80, 80)];
    [newActivityBtn setImage:[UIImage imageNamed:@"newActivity_btnBG"] forState:UIControlStateNormal];
    [newActivityBtn setImage:[UIImage imageNamed:@"newActivity_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [newActivityBtn setTag:NEWACTIVITY_BUTTON_TAG];
    [newActivityBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBGImageView addSubview:newActivityBtn];
    UILabel * newActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(newActivityBtn.frame.origin.x, newActivityBtn.frame.origin.y+newActivityBtn.frame.size.height, newActivityBtn.frame.size.width, 20)];
    [newActivityLabel setText:@"最新活动"];
    [newActivityLabel setBackgroundColor:[UIColor clearColor]];
    [newActivityLabel setTextAlignment:NSTextAlignmentCenter];
    [newActivityLabel setFont:[UIFont systemFontOfSize:12]];
    [homePageBGImageView addSubview:newActivityLabel];
    newActivityFrontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 50, 50)];
//    [newActivityFrontImageView setImage:[UIImage imageNamed:@"newActivity"]];
    [newActivityFrontImageView setCenter:newActivityBtn.center];
    [homePageBGImageView addSubview:newActivityFrontImageView];
    
    [self.view addSubview:homePageBGImageView];
    [self getInfo];
}

-(void)btnClicked:(UIButton*)sender
{
    NSLog(@"btnClicked and sender.tag = %d",sender.tag);
    
    
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
            
        }
            break;
        case BRANDINTRODUCTION_BUTTON_TAG:
        {
            AboutBesfulViewController * aboutBesful = [[AboutBesfulViewController alloc] init];
            [self.navigationController pushViewController:aboutBesful animated:YES];
        }
            break;
        case PRODINFO_BUTTON_TAG:
        {
            ProdInfoViewController * prodInfoVC = [[ProdInfoViewController alloc] init];
            [self.navigationController pushViewController:prodInfoVC animated:YES];
        }
            break;
        case SHARE_BUTTON_TAG:
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:nil  ofType:nil];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"分享内容:"
                                               defaultContent:@"来自besful"
                                                        image:[ShareSDK imageWithPath:nil]
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
        }
            break;
        case QRCODESCALE_BUTTON_TAG://二维码
        {
            ZViewController * zViewCtl=[[ZViewController alloc]init];
            [self.navigationController pushViewController:zViewCtl animated:YES];
        }
            break;
        case NEWACTIVITY_BUTTON_TAG:
        {
//            HotProdViewController * hotProdVC = [[HotProdViewController alloc] init];
//            [self.navigationController pushViewController:hotProdVC animated:YES];
            NewActivityViewController * newActivityVC = [[NewActivityViewController alloc] init];
            [self.navigationController pushViewController:newActivityVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- getNetwork
-(void)getInfo
{
    NSArray * imageArray=[[NSArray alloc]initWithObjects:
                          @"home_products.png",
                          @"home_introduce.png",
                          @"home_mybesful.png",
                          @"home_share.png",
                          @"home_news.png",
                          @"home_QR.png",nil];
    NSURL * postUrl;
    for (int i=0; i<[imageArray count]; i++) {
        NSString * imageString=[imageArray objectAtIndex:i];
        postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",homeImage_url,imageString]];
        ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:postUrl];
        [request setTag:1000+i];
        [requestArray addObject:request];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    [activityView startAnimating];
    [activityView setHidden:NO];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    switch (request.tag) {
        case 1000:
            //产品列表
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [prodInfoFrontImageView setImage:image];
        }
            break;
        case 1001://品牌介绍
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [brandIntroductionFrontImageView setImage:image];
        }
            break;
        case 1002://登录
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [myBesfulBtnFrontImageView setImage:image];
        }
            break;
        case 1003://分享
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [shareFrontImageView setImage:image];
        }
            break;
        case 1004: //最新活动
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [newActivityFrontImageView setImage:image];
        }
            break;
        case 1005: //扫描
        {
            UIImage * image=[UIImage imageWithData:request.responseData];
            [QRCodeScaleFrontImageView setImage:image];
        }
            break;
        default:
            break;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestError:%@",request.error);
    NSString * errStr=[NSString stringWithFormat:@"%@",request.error];
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:errStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alt show];

    [activityView stopAnimating];
    [activityView setHidesWhenStopped:YES];
    request.delegate = nil;
    [requestArray removeObject:request];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
