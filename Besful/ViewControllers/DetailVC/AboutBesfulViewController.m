//
//  AboutViewController.m
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "AboutBesfulViewController.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface AboutBesfulViewController ()

@end

@implementation AboutBesfulViewController

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
    [self initTopUI];
    UIImage * image=[[UIImage imageNamed:@"about_besul"]stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, 0, 321, 54)];
    [titleImageView setImage:image];
    [bodyBGImageView addSubview:titleImageView];
    [bodyBGImageView sendSubviewToBack:titleImageView];
    
    //init activity
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [activityView startAnimating];
    [self.view addSubview:activityView];

//    [self getInfo];
    
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
    
    
}
-(void)downloadImage
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, Screen_Height-20-50)];
    [scrollView setContentSize:CGSizeMake(320, 474)];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, Screen_Height-20)];
    [scrollView addSubview:imageView];
    [bodyBGImageView addSubview:scrollView];
    
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.besful-china.com/UserImage/besful_android/besful_introduce.jpg"]]];
    [imageView setImage:image];
    
    
    [activityView stopAnimating];
    [activityView setHidden:YES];
}

-(void)initUIWithString:(NSString *)string
{
    [self initTopUI];
    [bodyBGImageView setBackgroundColor:[UIColor whiteColor]];
    
    UIWebView * contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, 460)];
    [contentWebView loadHTMLString:string baseURL:nil];
    
    [bodyBGImageView addSubview:contentWebView];
}

-(void)getInfo
{
    NSString * rulDetail=@"BesfulDetail";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    [activityView startAnimating];
    [activityView setHidden:NO];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"[request responseString]====%@",[request responseString]);
    GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
    GDataXMLElement *rootElement = [docuemnt rootElement];
    NSString * respString=[rootElement.stringValue stringByReplacingOccurrencesOfString:@"~~~" withString:@"\\\""];
    respString=[respString stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    NSDictionary * arr=[respString JSONValue];
    NSString * getInfoString=[arr valueForKey:@"msg"];
    if (getInfoString==nil||[getInfoString isEqualToString:@""])
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，数据出错" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        NSLog(@"LOG:后台数据格式出错或者没有数据");
    }
    content=[NSString stringWithString:getInfoString];
    [self initUIWithString:content];
    
    request.delegate = nil;
    [requestArray removeObject:request];
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
