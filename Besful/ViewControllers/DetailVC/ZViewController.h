//
//  ZViewController.h
//  ZCodeDemo
//
//  Created by mac on 13-12-9.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "BaseViewController.h"

@interface ZViewController : BaseViewController <ZBarReaderDelegate,ZBarReaderViewDelegate>
{
    NSString * QRMessageString;//扫描之后得到的字符串
    
    ZBarReaderView * readerView;
}
@end
