//
//  ProdInfoViewController.m
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "ProdInfoViewController.h"
#import "ProdListIndexViewController.h"
#import "HotProdViewController.h"
#import "NewActivityViewController.h"
#import "ProdListViewController.h"

@interface ProdInfoViewController ()

@end

@implementation ProdInfoViewController

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
    [self performSelectorOnMainThread:@selector(initUI) withObject:nil waitUntilDone:NO];
    

}

-(void)initUI
{
    bodyBGImageView.image = [UIImage imageNamed:@"prodInfo_BG"];
    //all prod button
    UIButton * allProdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allProdBtn setFrame:CGRectMake(15, 130, 290, 25)];
    [allProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_normal"] forState:UIControlStateNormal];
    [allProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_highlighted"] forState:UIControlStateHighlighted];
    [allProdBtn setTitle:@"所有产品" forState:UIControlStateNormal];
    [allProdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allProdBtn setTag:ALLPROD_BUTTON_TAG];
    [allProdBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:allProdBtn];
    
    UIImage * whiteBallNormalImage = [UIImage imageNamed:@"whiteBall_normal"];
    UIImage * whiteBallHighlightedImage = [UIImage imageNamed:@"whiteBall_highlighted"];
    
    UIButton * whiteBallBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBallBtn1 setFrame:CGRectMake(255, 105, 50, 50)];
    [whiteBallBtn1 setBackgroundImage:whiteBallNormalImage forState:UIControlStateNormal];
    [whiteBallBtn1 setBackgroundImage:whiteBallHighlightedImage forState:UIControlStateHighlighted];
    [whiteBallBtn1 setTag:ALLPROD_BUTTON_TAG];
    [whiteBallBtn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:whiteBallBtn1];
    
    UIImageView * allProdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [allProdImageView setCenter:whiteBallBtn1.center];
    [allProdImageView setImage:[UIImage imageNamed:@"allProd_btn"]];
    [bodyBGImageView addSubview:allProdImageView];
    
    
    //new prod
    UIButton * newProdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newProdBtn setFrame:CGRectMake(15, 200, 290, 25)];
    [newProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_normal"] forState:UIControlStateNormal];
    [newProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_highlighted"] forState:UIControlStateHighlighted];
    [newProdBtn setTitle:@"新品组合" forState:UIControlStateNormal];
    [newProdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [newProdBtn setTag:NEWPROD_BUTTON_TAG];
    [newProdBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:newProdBtn];
    
    UIButton * whiteBallBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBallBtn2 setFrame:CGRectMake(15, 175, 50, 50)];
    [whiteBallBtn2 setBackgroundImage:whiteBallNormalImage forState:UIControlStateNormal];
    [whiteBallBtn2 setBackgroundImage:whiteBallHighlightedImage forState:UIControlStateHighlighted];
    [whiteBallBtn2 setTag:NEWPROD_BUTTON_TAG];
    [whiteBallBtn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:whiteBallBtn2];
    
    UIImageView * newProdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [newProdImageView setCenter:whiteBallBtn2.center];
    [newProdImageView setImage:[UIImage imageNamed:@"newProd_btn"]];
    [bodyBGImageView addSubview:newProdImageView];
    
    //hot prod
    UIButton * hotProdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotProdBtn setFrame:CGRectMake(15, 270, 290, 25)];
    [hotProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_normal"] forState:UIControlStateNormal];
    [hotProdBtn setBackgroundImage:[UIImage imageNamed:@"blueBar_highlighted"] forState:UIControlStateHighlighted];
    [hotProdBtn setTitle:@"人气畅销品" forState:UIControlStateNormal];
    [hotProdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotProdBtn setTag:HOTPROD_BUTTON_TAG];
    [hotProdBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:hotProdBtn];
    
    UIButton * whiteBallBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteBallBtn3 setFrame:CGRectMake(255, 245, 50, 50)];
    [whiteBallBtn3 setBackgroundImage:whiteBallNormalImage forState:UIControlStateNormal];
    [whiteBallBtn3 setBackgroundImage:whiteBallHighlightedImage forState:UIControlStateHighlighted];
    [whiteBallBtn3 setTag:HOTPROD_BUTTON_TAG];
    [whiteBallBtn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:whiteBallBtn3];
    
    UIImageView * hotProdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [hotProdImageView setCenter:whiteBallBtn3.center];
    [hotProdImageView setImage:[UIImage imageNamed:@"hotProd_btn"]];
    [bodyBGImageView addSubview:hotProdImageView];
}

-(void)btnClicked:(UIButton*)sender
{
    NSLog(@"btnAction and sender.tag = %d",sender.tag);
    switch (sender.tag)
    {
        case ALLPROD_BUTTON_TAG:
        {
            ProdListIndexViewController * prodListCtl=[[ProdListIndexViewController alloc]init];
            [self.navigationController pushViewController:prodListCtl animated:YES];
        }
            break;
        case NEWPROD_BUTTON_TAG:
        {
            HotProdViewController * hotProdListCtl=[[HotProdViewController alloc]init];
            [self.navigationController pushViewController:hotProdListCtl animated:YES];
        }
            break;
        case HOTPROD_BUTTON_TAG:
        {
            ProdListViewController * prodListViewCtl=[[ProdListViewController alloc]init];
            prodListViewCtl.pageTitle=@"人气畅销";
            prodListViewCtl.productIndex=@"-999";
            [self.navigationController pushViewController:prodListViewCtl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
