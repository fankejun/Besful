//
//  ProdListIndexViewController.h
//  Besful
//
//  Created by yzy on 13-11-22.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BaseViewController.h"
@interface ProdListIndexViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tableView;
    NSMutableArray * data;
    NSMutableArray * proData;
    NSMutableArray * prodListNameArr;
    NSMutableArray * listOneArray;
    NSMutableArray * listTwoArray;
    NSMutableArray * listThreeArray;
    
    int pagesize;
    int productSection;
    int pageindex;
    
    UIActivityIndicatorView * activityView;
    BOOL isExpend;
}
@end
