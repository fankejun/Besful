//
//  BaseTableViewController.h
//  YZYFrame
//
//  Created by yzy on 13-6-30.
//  Copyright (c) 2013年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     * base_tableView;
}


@property (nonatomic,strong) NSMutableArray  * showData_array;//显示在界面上的数据
@property (nonatomic,strong) NSMutableArray  * allData_array;//所有数据
@property (nonatomic,strong) NSMutableArray  * selectedData_array;//查询结果

@end
