//
//  HotProdViewController.m
//  Besful
//
//  Created by yzy on 13-11-24.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "NewActivityViewController.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "NewActivity.h"
#import "ASIHTTPRequest.h"
#import "NewActivityDetailViewController.h"

@interface NewActivityViewController ()

@end

@implementation NewActivityViewController

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
    headImages = [[NSMutableDictionary alloc] init];
    
    self.allData_array = [[NSMutableArray alloc] init];
    
    self.showData_array = self.allData_array;
    [self.view bringSubviewToFront:base_tableView];
    [base_tableView setFrame:CGRectMake(0, 130+52, 320, self.view.frame.size.height-130-52)];
    [base_tableView setContentSize:CGSizeMake(320, self.showData_array.count*80)];
    
    [base_tableView reloadData];
    
    [self getInfo];
    
}
-(void)initUI
{
    [self initTopUI];
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    CGFloat value = 204/255.0f;
    [titleBGLabel setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:@"最新活动"];
    [titleLabel setTextColor:[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleBGLabel addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:titleBGLabel];
    [bodyBGImageView sendSubviewToBack:titleBGLabel];
    
    //prod_top_head
    prodTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, titleBGLabel.frame.origin.y+titleBGLabel.frame.size.height, 280, 130)];
//    [prodTopImageView setImage:[UIImage imageNamed:@"prod_top_head"]];
    [bodyBGImageView addSubview:prodTopImageView];
    
    //init activity
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [self.view addSubview:activityView];
    
    NSString * s=@"http://besful-china.com/UserImage/besful_android/news_head.png";
    [self downloadHeadImage:s];
}
#pragma mark -- getNetWork info
-(void)getInfo
{
    NSString * rulDetail=@"productActivity";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    NSLog(@"postUrl==%@",postUrl);
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setTag:DOWNLOAD_TEXT_TAG];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    
    [request startAsynchronous];
    [activityView startAnimating];
}

-(void)downloadHeadImage:(NSString *)headUrlString
{
    NSURL * postUrl=[NSURL URLWithString:[headUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postUrl==%@",postUrl);
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setTag:DOWNLOAD_HEADIMAGE_TAG];
    [request setDelegate:self];
    
    [request startAsynchronous];
}

-(void)downloadImage:(NSString*)paramUrlString
{
    NSURL * postUrl=[NSURL URLWithString:[paramUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postUrl==%@",postUrl);
    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setTag:DOWNLOAD_IMAGE_TAG];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:paramUrlString,@"imageUrl", nil]];
//    [request setRequestMethod:@"Get"];
    [request setDelegate:self];
    
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    switch (request.tag)
    {
        case DOWNLOAD_TEXT_TAG:
        {
            NSLog(@"[request responseString]====%@",[request responseString]);
            //每次都清空原来的数据
            if ([self.allData_array count]!=0)
            {
                [self.allData_array removeAllObjects];
            }
            [activityView stopAnimating];
            [activityView setHidesWhenStopped:YES];
            
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
                    NewActivity * newActivity = [self getAnSimpleObject:[NewActivity class] withFromDictionary:dic];
                    [self.allData_array addObject:newActivity];
                    [self downloadImage:newActivity.COLUMN1];
                }
                self.showData_array = self.allData_array;
                NSLog(@"self.showData_array*****%@",self.showData_array);
            }
            else
            {
                UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有返回数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }
            [base_tableView reloadData];
        }
            break;
        case DOWNLOAD_IMAGE_TAG:
        {
            NSData * imageData = [request responseData];
            UIImage * image = [UIImage imageWithData:imageData];
            if (image!=nil)
            {
                NSString * imageUrl =[request.userInfo objectForKey:@"imageUrl"];
                int i=0;
                for (; i<self.showData_array.count; i++)
                {
                    NewActivity * newActivity = [self.showData_array objectAtIndex:i];
                    if ([imageUrl isEqualToString:newActivity.COLUMN1])
                    {
                        [headImages setObject:image forKey:[NSNumber numberWithInt:i]];
                        break;
                    }
                }
                
                NSArray * indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:i inSection:0], nil];
                [base_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
        }
            break;
        case  DOWNLOAD_HEADIMAGE_TAG:
        {
            NSData * imageData = [request responseData];
            UIImage * image = [UIImage imageWithData:imageData];
            [prodTopImageView setImage:image];
        }
            break;
            
        default:
            break;
    }
    
    
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

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NewActivity * newActivity = [self.showData_array objectAtIndex:indexPath.row];
    UIImage * image = nil;
    if ([headImages objectForKey:[NSNumber numberWithInteger:indexPath.row]])
    {
        image = [headImages objectForKey:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    [cell.imageView setImage:[self scaleToSize:image size:CGSizeMake(60, 60)]];
    
    [cell.textLabel setText:newActivity.NAME];
    [cell.textLabel setTextColor:[UIColor colorWithRed:10/255.0f green:76/255.0f blue:110/255.0f alpha:1.0]];
    NSArray * array = [newActivity.CREATERTIME componentsSeparatedByString:@" "];
    if (array.count>1)
    {
        [cell.detailTextLabel setText:[array objectAtIndex:0]];
    }
    
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:38/255.0f green:163/255.0f blue:232/255.0f alpha:1.0]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewActivity * newActivity = [self.showData_array objectAtIndex:indexPath.row];
    NewActivityDetailViewController * newActivityDetailVC = [[NewActivityDetailViewController alloc] init];
    newActivityDetailVC.activityUrl = newActivity.SINAURL;
    [self.navigationController pushViewController:newActivityDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
