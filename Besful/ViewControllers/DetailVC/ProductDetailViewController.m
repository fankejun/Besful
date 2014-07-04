//
//  ProductDetailViewController.m
//  Besful
//
//  Created by yzy on 13-11-24.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "ProdListIndex.h"
#import "SBJson.h"
#import "ProdItem.h"
#import "TaobaoViewController.h"
#import "ProdList.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContainer.h>

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController
@synthesize prodID;

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
    noneImage = [UIImage imageNamed:@"none"];
    [self getInfo];
    [self initUI];
}

-(void)initUI
{
    [self initTopUI];
    prodArray=[[NSMutableArray alloc]initWithCapacity:0];
    prodRelImageArray=[[NSMutableArray alloc]initWithCapacity:0];
    prodListArray=[[NSMutableArray alloc]initWithCapacity:0];
    UP=true;
    lableH=15.0f;
    font=[UIFont systemFontOfSize:14.0f];
    
    topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(45, 50, 230, 160)];
    [topImageView setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:topImageView];
    
    textColor1=[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0];
    UIColor * textColor2=[UIColor colorWithRed:106/255.0f green:199/255.0f blue:242/255.0f alpha:1.0];

    EnglishLable=[[UILabel alloc]initWithFrame:CGRectMake(20, topImageView.frame.size.height+topImageView.frame.origin.y+10, bodyBGImageView.frame.size.width-30, 21)];
//    [EnglishLable setText:@"ROSE ESSENTIAL OIL"];
    [EnglishLable setBackgroundColor:[UIColor clearColor]];
    [EnglishLable setTextAlignment:NSTextAlignmentLeft];
    [EnglishLable setTextColor:textColor1];
    [bodyBGImageView addSubview:EnglishLable];
    
    prodNameLable=[[UILabel alloc]initWithFrame:CGRectMake(20, EnglishLable.frame.size.height+EnglishLable.frame.origin.y+5, bodyBGImageView.frame.size.width-30, 20)];
//    [prodNameLable setText:@"法国玫瑰精油"];
    [prodNameLable setBackgroundColor:[UIColor clearColor]];
    [prodNameLable setTextAlignment:NSTextAlignmentLeft];
    [prodNameLable setTextColor:textColor2];
    [bodyBGImageView addSubview:prodNameLable];
    
    tempLable1 =[[UILabel alloc]initWithFrame:CGRectMake(30, prodNameLable.frame.size.height+prodNameLable.frame.origin.y+5, 35, lableH)];
    [tempLable1 setText:@"容量:"];
    [tempLable1 setFont:font];
    [tempLable1 setBackgroundColor:[UIColor clearColor]];
    [tempLable1 setTextAlignment:NSTextAlignmentLeft];
    [tempLable1 setTextColor:textColor1];
    [bodyBGImageView addSubview:tempLable1];
    
    proggLable=[[UILabel alloc]initWithFrame:CGRectMake(tempLable1.frame.size.width+tempLable1.frame.origin.x+15, prodNameLable.frame.size.height+prodNameLable.frame.origin.y+5, 60, lableH)];
//    [proggLable setText:@"5ml"];
    [proggLable setFont:font];
    [proggLable setBackgroundColor:[UIColor clearColor]];
    [proggLable setTextAlignment:NSTextAlignmentLeft];
    [proggLable setTextColor:textColor1];
    [bodyBGImageView addSubview:proggLable];

    tempLable2 =[[UILabel alloc]initWithFrame:CGRectMake(30, tempLable1.frame.size.height+tempLable1.frame.origin.y+5, 35, lableH)];
    [tempLable2 setText:@"价格:"];
    [tempLable2 setFont:font];
    [tempLable2 setBackgroundColor:[UIColor clearColor]];
    [tempLable2 setTextAlignment:NSTextAlignmentLeft];
    [tempLable2 setTextColor:textColor1];
    [bodyBGImageView addSubview:tempLable2];
    
    priceLable=[[UILabel alloc]initWithFrame:CGRectMake(tempLable2.frame.size.width+tempLable2.frame.origin.x+15, proggLable.frame.size.height+proggLable.frame.origin.y+5, 150, lableH)];
//    [priceLable setText:@""];
    [priceLable setFont:font];
    [priceLable setBackgroundColor:[UIColor clearColor]];
    [priceLable setTextAlignment:NSTextAlignmentLeft];
    [priceLable setTextColor:textColor1];
    [bodyBGImageView addSubview:priceLable];
    
    tempLable3 =[[UILabel alloc]initWithFrame:CGRectMake(30, tempLable2.frame.size.height+tempLable2.frame.origin.y+5, 35, lableH)];
    [tempLable3 setText:@"描述:"];
    [tempLable3 setFont:font];
    [tempLable3 setBackgroundColor:[UIColor clearColor]];
    [tempLable3 setTextAlignment:NSTextAlignmentLeft];
    [tempLable3 setTextColor:textColor1];
    [bodyBGImageView addSubview:tempLable3];
    
    explanationLable=[[UILabel alloc]initWithFrame:CGRectMake(tempLable3.frame.size.width+tempLable3.frame.origin.x+15, priceLable.frame.size.height+priceLable.frame.origin.y+5, bodyBGImageView.frame.size.width-tempLable3.frame.size.width-50, lableH)];
//    [explanationLable setText:@"高贵的花之皇后，花之精魂"];
    [explanationLable setFont:font];
    [explanationLable setBackgroundColor:[UIColor clearColor]];
    [explanationLable setTextAlignment:NSTextAlignmentLeft];
    [explanationLable setTextColor:textColor1];
    [bodyBGImageView addSubview:explanationLable];
    
    contentScroll=[[UITextView alloc]initWithFrame:CGRectMake(10, explanationLable.frame.size.height+explanationLable.frame.origin.y, bodyBGImageView.frame.size.width-20, bodyBGImageView.frame.size.height-explanationLable.frame.size.height-explanationLable.frame.origin.y-20)];
    [contentScroll setEditable:NO];
    [contentScroll setText:s];
    
    UIButton * weixinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [weixinBtn setFrame:CGRectMake(priceLable.frame.size.width+priceLable.frame.origin.x+3, tempLable1.frame.origin.y, 30, 30)];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"weixin_logo"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(goWeixin:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:weixinBtn];
    
    UIButton * payCarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [payCarBtn setFrame:CGRectMake(weixinBtn.frame.size.width+weixinBtn.frame.origin.x+3, weixinBtn.frame.origin.y, 30, 30)];
    [payCarBtn setBackgroundImage:[UIImage imageNamed:@"paymentCar"] forState:UIControlStateNormal];
    [payCarBtn addTarget:self action:@selector(goTaobao:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:payCarBtn];
    
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(bodyBGImageView.frame.size.width/2, bodyBGImageView.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [bodyBGImageView addSubview:activityView];
}

-(void)initButtomView
{
    if (prodListArray.count==0)
    {
        return;
    }
    [buttomView removeFromSuperview];
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, bodyBGImageView.frame.size.height-150, 320, 150)];
    [buttomView setBackgroundColor:[UIColor whiteColor]];
    
    UISwipeGestureRecognizer * swipeGestureRecongnizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [swipeGestureRecongnizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [buttomView addGestureRecognizer:swipeGestureRecongnizer];
    
    
    [bodyBGImageView addSubview:buttomView];
    
    arrowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setFrame:CGRectMake(0, 0, 320, 50)];
    [arrowBtn addTarget:self action:@selector(upOrDown:) forControlEvents:UIControlEventTouchUpInside];
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttomView.frame.size.width/2-15, 0, 30, lableH)];
    [arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
    [arrowBtn addSubview:arrowImageView];
    
    UILabel * tempLable4=[[UILabel alloc]initWithFrame:CGRectMake(tempLable3.frame.origin.x, arrowBtn.frame.size.height+arrowBtn.frame.origin.y-20, 70, lableH)];
    [tempLable4 setText:@"相关产品:"];
    [tempLable4 setFont:font];
    [tempLable4 setBackgroundColor:[UIColor clearColor]];
    [tempLable4 setTextAlignment:NSTextAlignmentLeft];
    [tempLable4 setTextColor:textColor1];
    [buttomView addSubview:tempLable4];
    [buttomView addSubview:arrowBtn];
    
    float imageY=tempLable4.frame.size.height+tempLable4.frame.origin.y;
    float imageH=buttomView.frame.size.height-imageY;
    imageContentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, imageY, 320, imageH)];
    [buttomView addSubview:imageContentView];
    
    int pageCount = 0;
    if (prodListArray.count/4.0>prodListArray.count/4)
    {
        pageCount = prodListArray.count/4+1;
    }
    else
    {
        pageCount = prodListArray.count/4;
    }
    [imageContentView setContentSize:CGSizeMake(pageCount*320, imageContentView.frame.size.height)];
    [imageContentView setPagingEnabled:YES];
}

-(void)addButtomImage:(NSArray *)array
{
    for (int j=0;j<array.count;j++)
    {
        NSLog(@"dddddd:%d",[array count]);
        UIImage * image=[array objectAtIndex:j];
        UIButton * imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [imageButton setFrame:CGRectMake(80*j+11.5, 10, 57, 57)];
        [imageButton setBackgroundImage:image forState:UIControlStateNormal];
        if (image!=noneImage)
        {
            [imageButton addTarget:self action:@selector(goSelf:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [imageButton setTag:10000+j];
        [imageContentView addSubview:imageButton];
    }
}

//相关产品跳转
-(void)goSelf:(UIButton *)sender
{
    NSLog(@"self.prodID=======%@",self.prodID);
    NSLog(@"goSelf**********");
    int tag=sender.tag-10000;
    ProdList * item=[prodListArray objectAtIndex:tag];
    self.prodID=[NSString stringWithFormat:@"%@",item.ID];
    NSLog(@"self.prodID=======%@",self.prodID);
//    NSLog(@"%@",item.ID);
    for (ASIHTTPRequest * elem in requestArray)
    {
        [elem clearDelegatesAndCancel];
        elem.delegate = nil;
    }
    [requestArray removeAllObjects];
    [prodArray removeAllObjects];
    [prodListArray removeAllObjects];
    [prodRelImageArray removeAllObjects];
    [self getInfo];
    [self initUI];
}

-(void)goWeixin:(UIButton *)sender
{
    NSLog(@"微信");
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"分享内容:%@",prodInfo]
                                       defaultContent:@"来自besful"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"Besful"
                                                  url:prodUrl
                                          description:prodInfo
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

-(void)goTaobao:(UIButton *)sender
{
    NSLog(@"购物车");
    ProdItem * item=[prodArray objectAtIndex:0];
    TaobaoViewController * taobaoCtl=[[TaobaoViewController alloc]init];
    taobaoCtl.urlString=item.TAOBAO;
    [self.navigationController pushViewController:taobaoCtl animated:YES];
}

-(void)upOrDown:(id)sender
{
    UP=!UP;
    if (UP)
    {
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_down"]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        CGRect frame=buttomView.frame;
        frame.origin.y -= buttomView.frame.size.height-20;
        buttomView.frame=frame;
        buttomViewDownY = frame.origin.y;
        [UIView commitAnimations];
    }
    else
    {
        [arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        CGRect frame=buttomView.frame;
        frame.origin.y += buttomView.frame.size.height-20;
        buttomView.frame=frame;
        buttomViewUpY = frame.origin.y;
        [UIView commitAnimations];
    }
}

-(void)gestureAction:(id)sender
{
    UISwipeGestureRecognizer * swipeGesture = (UISwipeGestureRecognizer*)sender;
    switch (swipeGesture.direction)
    {
        case UISwipeGestureRecognizerDirectionDown:
        {
            UP=!UP;
            [arrowImageView setImage:[UIImage imageNamed:@"arrow_up"]];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            CGRect frame=buttomView.frame;
            frame.origin.y += buttomView.frame.size.height-20;
            buttomView.frame=frame;
            [UIView commitAnimations];
        }
            break;
        default:
            break;
    }
}

-(void)downloadImage:(NSString*)paramUrlString AndWtihType:(NSString *)type AndIndex:(NSInteger)index
{
    NSURL * postUrl=[NSURL URLWithString:[paramUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postUrl:%@",postUrl);
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setTag:DOWNLOAD_IMAGE_TAG];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:type,@"image_type",[NSString stringWithFormat:@"%d",index],@"image_index", nil]];
    //    [request setRequestMethod:@"Get"];
    [request setDelegate:self];
    [request startAsynchronous];
    [activityView startAnimating];
}

#pragma mark -- getNetWork info
-(void)getInfo
{
    NSString * rulDetail=@"ProductDetail";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setTag:DOWNLOAD_TEXT_TAG];
    [request setDelegate:self];
    [request setPostValue:self.prodID forKey:@"productId"];
    [request startAsynchronous];
    [activityView startAnimating];
    prodUrl=[NSString stringWithFormat:@"%@?itemId=%@",share_url,prodID];
    NSLog(@"prodUrl:%@",[prodUrl description]);
}

-(void)getProdRel
{
    NSString * rulDetail=@"ProductRel";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    NSLog(@"posturl===%@",postUrl);
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setTag:DOWNLOAD_PRODREL];
    [request setDelegate:self];
    [request setPostValue:self.prodID forKey:@"productId"];
    [request startAsynchronous];
    [activityView startAnimating];

}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    switch (request.tag) {
        case DOWNLOAD_TEXT_TAG:
        {
            NSLog(@"[request responseString]====%@",[request responseString]);
            GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
            GDataXMLElement *rootElement = [docuemnt rootElement];
            NSDictionary * arr=[rootElement.stringValue JSONValue];
            NSString * resultStatus=[arr valueForKey:@"success"];
            NSString * resultMsg=[arr valueForKey:@"msg"];
            if ([resultStatus isEqualToString:@"true"]&&[resultMsg isEqualToString:@"ok"])
            {
                NSArray * resultArray=[arr valueForKey:@"Orders"];
                for (NSDictionary * dic in resultArray)
                {
                    ProdItem * prodItem = [self getAnSimpleObject:[ProdItem class] withFromDictionary:dic];
                    [prodArray addObject:prodItem];
                    [self downloadImage:prodItem.IMGSRC AndWtihType:@"1" AndIndex:0];
                }
                [self refreshView];
                [self getProdRel];
            }
            else
            {
                UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有返回数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }
            [activityView stopAnimating];

        }
            break;
        case DOWNLOAD_IMAGE_TAG:
        {
            NSString * image_type = [request.userInfo objectForKey:@"image_type"];
            if ([image_type isEqualToString:@"1"]) //大图
            {
                NSData * imageData = [request responseData];
                UIImage * image = [UIImage imageWithData:imageData];
                [topImageView setImage:image];
            }
            else //小图
            {
                NSString * indexStr = [request.userInfo objectForKey:@"image_index"];
                [prodRelImageArray replaceObjectAtIndex:[indexStr integerValue] withObject:[UIImage imageWithData:[request responseData]]];
            }
            [self addButtomImage:prodRelImageArray];
        }
            break;
        case DOWNLOAD_PRODREL:
        {
            NSLog(@"[request responseString]====%@",[request responseString]);
            GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
            GDataXMLElement *rootElement = [docuemnt rootElement];
            NSDictionary * arr=[rootElement.stringValue JSONValue];
            NSString * resultStatus=[arr valueForKey:@"success"];
            NSString * resultMsg=[arr valueForKey:@"msg"];
            if ([resultStatus isEqualToString:@"true"]&&[resultMsg isEqualToString:@"ok"])
            {
                NSArray * resultArray=[arr valueForKey:@"Orders"];
                int count = resultArray.count;
                for (int i=0;i<count;i++)
                {
                    NSDictionary * dic = [resultArray objectAtIndex:i];
                    ProdList * prodlist = [self getAnSimpleObject:[ProdList class] withFromDictionary:dic];
                    [prodListArray addObject:prodlist];
                    
                    [prodRelImageArray addObject:noneImage];
                    [self downloadImage:prodlist.IMGSRC AndWtihType:@"2" AndIndex:i];
                }
                if (prodListArray.count>0)
                    [self initButtomView];
            }
            else
            {
                UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有返回数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }
            [activityView stopAnimating];
        }
            break;
        default:
            break;
    }
    [activityView setHidesWhenStopped:YES];
    request.delegate = nil;
    [requestArray removeObject:request];
}

-(void)refreshView
{
    ProdItem * item=nil;
    if (prodArray.count>0)
    {
        item=[prodArray objectAtIndex:0];
    }
    
    EnglishLable.text=item.ENGLISHNAME;
    prodNameLable.text=item.PRONAME;
    prodInfo=item.PRONAME;
    proggLable.text=item.PROGG;
    priceLable.text=[NSString stringWithFormat:@"￥%@",item.PRICE];
    explanationLable.text=[item.EXPLANATION stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    s=[item.EFFICACY stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];

    
    [contentScroll setText:s];
    [contentScroll setFont:font];
    [contentScroll setBackgroundColor:[UIColor clearColor]];
    [contentScroll setTextAlignment:NSTextAlignmentLeft];
    [contentScroll setTextColor:textColor1];
    [bodyBGImageView addSubview:contentScroll];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestError:%@",request.error);
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
