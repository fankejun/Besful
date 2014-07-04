//
//  NewActivityDetailViewController.h
//  Besful
//
//  Created by yzy on 13-12-6.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "BaseViewController.h"

@interface NewActivityDetailViewController : BaseViewController
{
    UIWebView * _webView;
    UIActivityIndicatorView * activityView;
}
@property (nonatomic,strong)NSString * activityUrl;

@end
