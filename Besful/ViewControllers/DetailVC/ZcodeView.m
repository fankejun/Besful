//
//  ZcodeView.m
//  Besful
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "ZcodeView.h"
#import "ASIFormDataRequest.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "ProductDetailViewController.h"

@implementation ZcodeView
@synthesize QRMessageString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        requestArray=[[NSMutableArray alloc]initWithCapacity:0];
        [self initScanleView];
    }
    return self;
}


-(void)initScanleView
{
    UILabel * redlineLable=[[UILabel alloc]initWithFrame:CGRectMake(20,self.frame.size.height/2-1, 280, 2)];
    [redlineLable setBackgroundColor:[UIColor redColor]];
    [self addSubview:redlineLable];
    
    //返回按钮
    UIButton * goBackbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goBackbutton setFrame:CGRectMake(5, 5, 40, 30)];
    [goBackbutton setTitle:@"返回" forState:UIControlStateNormal];
    [goBackbutton addTarget:self action:@selector(goFront:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goBackbutton];
    
    //闪光灯开关
    UISwitch * lightSwith=[[UISwitch alloc]initWithFrame:CGRectMake(self.frame.size.width-100,5,80,40)];
    [lightSwith setOn:NO];
    [lightSwith addTarget:self action:@selector(changeLight:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:lightSwith];
    
    //扫描区域
    self.scanCrop=CGRectMake(0, 0, 1, 1);
    self.torchMode=0;
    [self start];

}

#pragma mark -- 闪光灯
-(void)changeLight:(UISwitch *)sender
{
    if(sender.on)
    {
        //打开闪光灯
        self.torchMode = 1;
    }
    else
    {
        //关闭闪光
        self.torchMode = 0;
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
}

#pragma mark -- getInfoFromScanle
-(void)getProuctInfo
{
    NSString * rulDetail=@"getProductIdByCode";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [request setTag:20001];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setPostValue:QRMessageString forKey:@"code"];
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //扫描成功
    GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
    GDataXMLElement *rootElement = [docuemnt rootElement];
    NSDictionary * arr=[rootElement.stringValue JSONValue];
    NSString * resultStatus=[arr valueForKey:@"success"];
    if ([resultStatus isEqualToString:@"true"]) {
        NSString * resultMsg=[arr valueForKey:@"msg"];
        //                UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:resultMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //                [alt show];
        ProductDetailViewController * productDetCtl=[[ProductDetailViewController alloc]init];
        productDetCtl.prodID=resultMsg;
        [self navigationController pushViewController:productDetCtl animated:YES];
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
