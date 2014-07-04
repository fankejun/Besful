//
//  HomePageViewController.h
//  Besful
//
//  Created by yzy on 13-11-20.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"

@interface HomePageViewController : BaseViewController <ZBarReaderViewDelegate>
{
    UIImageView * myBesfulBtnFrontImageView;
    UIImageView * brandIntroductionFrontImageView;
    UIImageView * prodInfoFrontImageView;
    UIImageView * shareFrontImageView;
    UIImageView * QRCodeScaleFrontImageView;
    UIImageView * newActivityFrontImageView;
    
    UIActivityIndicatorView * activityView;
    
    ZBarReaderView * readerView;
    NSString * QRMessageString;//扫描之后得到的字符串
}
@end
