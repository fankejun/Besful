//
//  ProdListViewController.h
//  Besful
//
//  Created by yzy on 13-11-23.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "BaseTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface ProdListViewController : BaseTableViewController<EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView* _refreshHeaderView;
    BOOL _reloading;
    
    UILabel * footView;
    
    UIActivityIndicatorView * activityView;
    NSMutableDictionary * headImages;
    NSInteger pagesize;
    NSInteger pageindex;
    
    BOOL isLoadedAllData;
}

@property (nonatomic,strong)NSString * productIndex;
@property (nonatomic,strong)NSString * pageTitle;

@end
