//
//  ProdListViewController.m
//  Besful
//
//  Created by yzy on 13-11-23.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "ProdListViewController.h"
#import "ProductDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "ProdList.h"

@interface ProdListViewController ()

@end

@implementation ProdListViewController
@synthesize productIndex,pageTitle;


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
	// Do any additional setup after loading the view.
    self.allData_array = [[NSMutableArray alloc] init];
    headImages = [[NSMutableDictionary alloc] init];
    self.showData_array = self.allData_array;
    [self initUI];
    pagesize = 10;
    pageindex = 1;
    [self getInfo];
    
}

-(void)initUI
{
    [self initTopUI];
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    [titleBGLabel setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:pageTitle];
    [titleLabel setTextColor:[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleBGLabel addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [bodyBGImageView addSubview:titleBGLabel];
    [bodyBGImageView sendSubviewToBack:titleBGLabel];
    
    [self.view bringSubviewToFront:base_tableView];
    [base_tableView setContentSize:CGSizeMake(320, self.showData_array.count*80)];
    [self addFootView];
    [footView setText:@"正在加载数据"];
    if (_refreshHeaderView==nil) {
        EGORefreshTableHeaderView* view1=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f, -self.view.bounds.size.height, base_tableView.frame.size.width, self.view.bounds.size.height)];
        view1.delegate=self;
        [base_tableView addSubview:view1];
        _refreshHeaderView=view1;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    [base_tableView reloadData];
    
    //init activity
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [self.view addSubview:activityView];
}
-(void)getInfo
{
    NSString * rulDetail=@"GetProductList";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    NSLog(@"postUrl==%@",postUrl);
    NSLog(@"productindex=%@",self.productIndex);
    NSLog(@"pagesize=%d",pagesize);
    NSLog(@"pageindex=%d",pageindex);
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setTag:DOWNLOAD_TEXT_TAG];
    [request setPostValue:self.productIndex forKey:@"productindex"];
    [request setPostValue:[NSString stringWithFormat:@"%d",pagesize] forKey:@"pagesize"];
    [request setPostValue:[NSString stringWithFormat:@"%d",pageindex] forKey:@"pageindex"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    
    [request startAsynchronous];
    [activityView startAnimating];
}

-(void)downloadImage:(NSString*)paramUrlString
{
    NSURL * postUrl=[NSURL URLWithString:[paramUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postUrl:%@",postUrl);
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
            if (pageindex==1)
            {
                //每次都清空原来的数据
                if ([self.allData_array count]!=0)
                {
                    [self.allData_array removeAllObjects];
                    isLoadedAllData = NO;
                }
            }
            [self doneLoadingTableViewData];
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
                if (resultArray.count<pagesize)
                {
                    isLoadedAllData = YES;
                }
                for (NSDictionary * dic in resultArray)
                {
                    ProdList * prodList = [self getAnSimpleObject:[ProdList class] withFromDictionary:dic];
                    [self.allData_array addObject:prodList];
                    [self downloadImage:prodList.IMGSRC];
                }
                self.showData_array = self.allData_array;
            }
            else
            {
                UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有返回数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alt show];
            }
            if (self.showData_array.count>(4+Is4_0inch*1))
            {
                [self addFootView];
            }
            else
            {
                [self removeFootView];
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
                int i = 0;
                for (; i<self.showData_array.count; i++)
                {
                    ProdList * prodList = [self.showData_array objectAtIndex:i];
                    if ([imageUrl isEqualToString:prodList.IMGSRC])
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
            
        default:
            break;
    }
    request.delegate = nil;
    [requestArray removeObject:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestError:%@",request.error);
    [self doneLoadingTableViewData];
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
    
    UIImage * image = nil;
    if ([headImages objectForKey:[NSNumber numberWithInteger:indexPath.row]])
    {
        image = [headImages objectForKey:[NSNumber numberWithInteger:indexPath.row]];
        NSLog(@"image:%@",image);
    }
    [cell.imageView setImage:[self scaleToSize:image size:CGSizeMake(55, 60)]];
    
    UIImageView * accessortyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 25)];
    [accessortyView setImage:[UIImage imageNamed:@"arrow_blue"]];
    [cell setAccessoryView:accessortyView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.showData_array.count>indexPath.row)
    {
        ProdList * elem =[self.showData_array objectAtIndex:indexPath.row];
        [cell.textLabel setText:elem.ENGLISHNAME];
        [cell.textLabel setTextColor:[UIColor colorWithRed:10/255.0f green:76/255.0f blue:110/255.0f alpha:1.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
        [cell.detailTextLabel setText:[elem PRONAME]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:38/255.0f green:163/255.0f blue:232/255.0f alpha:1.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:18]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController * prodDetailCtl=[[ProductDetailViewController alloc]init];
    prodDetailCtl.prodID = ((ProdList*)[self.showData_array objectAtIndex:indexPath.row]).ID;
    [self.navigationController pushViewController:prodDetailCtl animated:YES];
}




- (void)reloadTableViewDataSource
{
    
    NSLog(@"==开始加载数据");
    _reloading=YES;
    //[self.myTableView reloadData];
    
}
- (void)doneLoadingTableViewData
{
    NSLog(@"==加载万数据");
    _reloading=NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:base_tableView];
}


#pragma UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
//    NSLog(@"scrollViewdidscroller");
    CGSize base_tableView_contentSize = base_tableView.contentSize;
    CGPoint base_tableView_contentOffset = base_tableView.contentOffset;
    if (base_tableView_contentOffset.y+base_tableView.frame.size.height>base_tableView_contentSize.height-20)
    {
        if (_reloading==YES)
        {
            NSLog(@"正在加载");
            [footView setText:@"正在加载"];
        }
        else if(isLoadedAllData==NO)
        {
            [footView setText:@"上拉可以加载"];
        }
        else
        {
            [footView setText:@"加载完所有数据"];
        }
    }
}
-(void)addFootView
{
    footView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [footView setText:@"上拉可以加载"];
    [footView setFont:[UIFont systemFontOfSize:14]];
    [footView setTextColor:[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0]];
    [footView setTextAlignment:NSTextAlignmentCenter];
    [base_tableView setTableFooterView:footView];
}

-(void)removeFootView
{
    [footView removeFromSuperview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    NSLog(@"scrollViewdidscroller11111111");
    CGSize base_tableView_contentSize = base_tableView.contentSize;
    CGPoint base_tableView_contentOffset = base_tableView.contentOffset;
    if (base_tableView_contentOffset.y+base_tableView.frame.size.height>base_tableView_contentSize.height-20)//上拉加载
    {
        NSLog(@"上拉加载");
        if (_reloading==YES)
        {
            [footView setText:@"正在加载数据"];
        }
        else if(isLoadedAllData==YES)
        {
            [footView setText:@"加载完所有数据"];
        }
        else
        {
            pageindex +=1;
            [self getInfo];
        }
    }
}
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    pageindex = 1;
    [self getInfo];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
