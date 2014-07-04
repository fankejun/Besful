//
//  ProdListIndexViewController.m
//  Besful
//
//  Created by yzy on 13-11-22.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "ProdListIndexViewController.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "ProdListIndex.h"
#import "ProdListViewController.h"

@interface ProdListIndexViewController ()

@end

@implementation ProdListIndexViewController

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
    pagesize=5;
    pageindex=1;
    isExpend=NO;
    [self initTopUI];
    [self performSelectorOnMainThread:@selector(initUI) withObject:nil waitUntilDone:NO];
}

-(void)initUI
{
    bodyBGImageView.image = [UIImage imageNamed:@"prodList_BG"];
    
    //init Data
    data = [[NSMutableArray alloc]initWithCapacity : 0];
    proData=[[NSMutableArray alloc]initWithCapacity:0];
    prodListNameArr=[[NSMutableArray alloc]initWithCapacity:0];
    listOneArray=[[NSMutableArray alloc]initWithCapacity:0];
    listTwoArray=[[NSMutableArray alloc]initWithCapacity:0];
    listThreeArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    [self getInfo];
    //init activity
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [activityView setColor:[UIColor blueColor]];
    [self.view addSubview:activityView];
}

-(void)initTableView
{
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, 320, self.view.frame.size.height-90) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView setSeparatorColor:[UIColor blackColor]];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
//    [tableView reloadData];
    [self setExtraCellLineHidden:tableView];
}

//返回指定节的“expanded”值
//-(Boolean)isExpanded:(int)section{
//    
//}

//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    isExpend = !isExpend;
	UIButton* btn= (UIButton*)sender;
	int section= btn.tag; //取得tag知道点击对应哪个块
    if (section==0)
    {
        productSection=1;
        proData=listOneArray;
    }
    if (section==1)
    {
        productSection=2;
        proData=listTwoArray;
    }
    if (section==2)
    {
        productSection=3;
        proData=listThreeArray;
    }
    if (section==3)
    {
        isExpend = !isExpend;
        ProdListViewController * prodListCtl=[[ProdListViewController alloc]init];
        prodListCtl.pageTitle=@"产品列表";
        prodListCtl.productIndex = @"-7";
        [self.navigationController pushViewController:prodListCtl animated:YES];
    }
    [tableView reloadData];
}

#pragma mark -- tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return   [prodListNameArr count];
//    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
        {
            if (productSection==1 && isExpend)
            {
                return listOneArray.count;
            }
            return 0;
        }
            break;
        case 1:
        {
            if (productSection==2 && isExpend)
            {
                return listTwoArray.count;
            }
            return 0;
        }
            break;
        case 2:
        {
            if (productSection==3 && isExpend)
            {
                return listThreeArray.count;
            }
            return 0;
        }
            break;
        case 3:
        {
            return 0;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
//    if (isExpend==NO)
//        return 0;
//    else
//        return [proData count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * ideString=@"ideCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:ideString];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideString];
    }
    ProdListIndex * prodItem = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            prodItem=[listOneArray objectAtIndex:indexPath.row];
        }
            break;
        case 1:
        {
            prodItem=[listTwoArray objectAtIndex:indexPath.row];
        }
            break;
        case 2:
        {
            prodItem=[listThreeArray objectAtIndex:indexPath.row];
        }
            break;
        default:
            break;
    }
    
	if (prodItem== nil) {
		return cell;
	}
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [cell.textLabel setText:prodItem.NAME];
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:187/255.0f green:240/255.0f blue:241.0f alpha:1.0f]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    
    NSString * productionIndex = ((ProdListIndex*)[proData objectAtIndex:indexPath.row]).ID;
    if (productionIndex.length==0)
    {
        return;
    }
        
    ProdListViewController * prodListCtl=[[ProdListViewController alloc]init];
    prodListCtl.pageTitle=@"产品列表";
    prodListCtl.productIndex = productionIndex;
    [self.navigationController pushViewController:prodListCtl animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
	UIView *hView;
    hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 68)];
    UIButton* eButton = [[UIButton alloc] init];
    NSString * prodname=[prodListNameArr objectAtIndex:section];
    [eButton setTitle:prodname forState:UIControlStateNormal];
    //按钮,还差在button下面加一条线
    eButton.frame = hView.frame;
    [eButton addTarget:self action:@selector(expandButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
    [eButton setBackgroundColor:[UIColor colorWithRed:29/255.0f green:126/255.0f blue:165/255.0f alpha:1.0f]];
    //设置按钮显示颜色
    [eButton.titleLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hView addSubview: eButton];
    
    UIImageView * lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, eButton.frame.size.height+eButton.frame.origin.y, 320, 2)];
//    [lineView setImage:[UIImage imageNamed:@"prodList_sepLineL"]];
    [lineView setBackgroundColor:[UIColor blackColor]];
    [hView addSubview:lineView];
    return hView;
}

//去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -- getNetWork info
-(void)getInfo
{
    NSString * rulDetail=@"Navigation";
    NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
    ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
    [requestArray addObject:request];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    [activityView startAnimating];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"[request responseString]====%@",[request responseString]);
    //每次都清空原来的数据
//    if ([proData count]!=0)
//    {
//        [proData removeAllObjects];
//    }
    [activityView stopAnimating];
    [activityView setHidesWhenStopped:YES];
    NSMutableArray * tempNameArr=[[NSMutableArray alloc]initWithCapacity:0];
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
            ProdListIndex * prodItem = [self getAnSimpleObject:[ProdListIndex class] withFromDictionary:dic];
//            ProdListIndex * prodItem=[[ProdListIndex alloc]init];
//            prodItem.prodListID=[dic objectForKey:@"id"];
//            prodItem.prodListName=[dic objectForKey:@"name"];
//            prodItem.parentid=[dic objectForKey:@"parentid"];
            if ([prodItem.PARENTID isEqualToString:@"-1"])
            {
                [tempNameArr addObject:prodItem];
            }
            if ([prodItem.PARENTID isEqualToString:@"1"]){
                [listOneArray addObject:prodItem];
            }
            if ([prodItem.PARENTID isEqualToString:@"10"])
            {
                [listTwoArray addObject:prodItem];
            }
            if ([prodItem.PARENTID isEqualToString:@"11"])
            {
                [listThreeArray addObject:prodItem];
            }
        }
    }
    else
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有返回数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }
    //调换顺序
    ProdListIndex * item1=[[ProdListIndex alloc]init];
    item1=[tempNameArr objectAtIndex:0];
    ProdListIndex * item2=[[ProdListIndex alloc]init];
    item2=[tempNameArr objectAtIndex:1];
    ProdListIndex * item3=[[ProdListIndex alloc]init];
    item3=[tempNameArr objectAtIndex:2];
    prodListNameArr=[NSMutableArray arrayWithObjects:item2.NAME,item3.NAME,@"功能分类",item1.NAME,nil];
    [self initTableView];
    [tableView reloadData];
    
    
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
