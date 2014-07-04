//
//  ZViewController.m
//  ZCodeDemo
//
//  Created by mac on 13-12-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "ZViewController.h"
#import "ASIFormDataRequest.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "ProductDetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZViewController ()
@property (nonatomic,strong) AVCaptureDevice * captureDevice;
@property (nonatomic,strong) AVCaptureSession * captureSession;
@end

@implementation ZViewController

-(void)dealloc
{
    [super dealloc];
    if (readerView!=nil)
    {
        [readerView release];
        readerView=nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"二维码扫描"];
        [self.navigationController setNavigationBarHidden:NO];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self initScanle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI
{
    [self initTopUI];
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    CGFloat value = 204/255.0f;
    [titleBGLabel setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:@"产品扫描"];
    [titleLabel setTextColor:[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleBGLabel addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:titleBGLabel];
    [bodyBGImageView sendSubviewToBack:titleBGLabel];
    
    [titleBGLabel release];
    [titleLabel release];
}

#pragma mark -- 扫描
-(void)initScanle
{
    NSLog(@"start");
//    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"message" message:@"start" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alt show];
    if (readerView!=nil)
    {
        [readerView flushCache];
    }
    readerView=[[ZBarReaderView alloc]init];
    [readerView setFrame:CGRectMake(0, 54+20*IsIOS7, self.view.frame.size.width, self.view.frame.size.height)];
    [readerView setReaderDelegate:self];
    
    UILabel * redlineLable=[[UILabel alloc]initWithFrame:CGRectMake(20,readerView.frame.size.height/2-1, 280, 2)];
    [redlineLable setBackgroundColor:[UIColor redColor]];
    [readerView addSubview:redlineLable];
    
    //闪光灯开关
    UISwitch * lightSwith=[[UISwitch alloc]initWithFrame:CGRectMake(readerView.frame.size.width-100,5,80,40)];
    [lightSwith setOn:NO];
    [lightSwith addTarget:self action:@selector(changeLight:) forControlEvents:UIControlEventValueChanged];
    [readerView addSubview:lightSwith];
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR)
    {
        ZBarCameraSimulator * cameraSimulator=[[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView=readerView;
        [cameraSimulator release];
    }
    [self.view addSubview:readerView];
    
    //扫描区域
    readerView.scanCrop=CGRectMake(0, 0, 1, 1);
    //进入之后默认关闭闪光灯
    readerView.torchMode=0;
    [readerView start];
    
    [redlineLable release];
    [lightSwith release];
}

#pragma mark -- 闪光灯
-(void)changeLight:(UISwitch *)sender
{
    if(sender.on)
    {
        //打开闪光灯
        readerView.torchMode = 1;
    }
    else
    {
        //关闭闪光
        readerView.torchMode = 0;
    }
}

#pragma mark -- ZBarReaderView Delegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol * symbol in symbols) {
        NSLog(@"%@",symbol.data);
        QRMessageString=[NSString stringWithFormat:@"%@",symbol.data];
        //        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"Code" message:symbol.data delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alt show];
        break;
    }
    [readerView stop];
    [self getinfo];
}

#pragma mark -- getInfoFromScanle
-(void)getinfo
{
    NSString * rulDetail=@"getProductIdByCode";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setPostValue:QRMessageString forKey:@"code"];
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
    GDataXMLElement *rootElement = [docuemnt rootElement];
    NSDictionary * arr=[rootElement.stringValue JSONValue];
    NSString * resultStatus=[arr valueForKey:@"success"];
    if ([resultStatus isEqualToString:@"true"]) {
        NSString * resultMsg=[arr valueForKey:@"msg"];
        ProductDetailViewController * productDetCtl=[[ProductDetailViewController alloc]init];
        productDetCtl.prodID=resultMsg;
        [self.navigationController pushViewController:productDetCtl animated:YES];
        [productDetCtl release];
    }
    else{
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，没有找到该商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        [alt release];
        [self initScanle];
    }
    [docuemnt release];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString * errString=[NSString stringWithFormat:@"%@",request.error];
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:errString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alt show];
    [alt release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
