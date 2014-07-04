//
//  TaobaoViewController.m
//  Besful
//
//  Created by 樊 柯均 on 13-11-24.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "TaobaoViewController.h"

@interface TaobaoViewController ()
@end

@implementation TaobaoViewController
@synthesize urlString;

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
    [self initUIWithString:urlString];
	// Do any additional setup after loading the view.
}

-(void)initUIWithString:(NSString *)string
{
    [self initTopUI];
    [bodyBGImageView setBackgroundColor:[UIColor whiteColor]];
    
    UIWebView * contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, 320, 460)];
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    [contentWebView loadRequest:request];
    [bodyBGImageView addSubview:contentWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
