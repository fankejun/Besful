//
//  ZcodeView.h
//  Besful
//
//  Created by mac on 13-12-26.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ZcodeView :ZBarReaderView <ZBarReaderViewDelegate>
{
    NSMutableArray * requestArray;
}
@property (nonatomic,copy) NSString * QRMessageString;
@end
