//
//  NewActivityDetailViewController.m
//  Besful
//
//  Created by yzy on 13-12-6.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "NewActivityDetailViewController.h"

@interface NewActivityDetailViewController ()

@end

@implementation NewActivityDetailViewController

@synthesize activityUrl;

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
	// Do any additional setup after loading the view.
    [self performSelectorOnMainThread:@selector(initUI) withObject:nil waitUntilDone:NO];
}
-(void)initUI
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, Screen_Height-64-20)];
    [bodyBGImageView insertSubview:_webView atIndex:0];
    
    NSURL * url = [NSURL URLWithString:activityUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    _webView.delegate = self;
    [_webView loadRequest:request];
    
    //init activity
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [activityView startAnimating];
    [self.view addSubview:activityView];
}

#pragma mark UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityView stopAnimating];
    [activityView setHidden:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityView stopAnimating];
    [activityView setHidden:YES];
    NSLog(@"error:%@",error.description);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
