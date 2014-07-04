//
//  RequestHelper.h
//  Frame
//
//  Created by yzy on 13-6-29.
//  Copyright (c) 2013年 yzy. All rights reserved.
//

typedef enum
{
    ADDUSERINFO=1001,
    GETUSERINFOINFORMATION=1002,
}Account;

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject
{
    NSString * _hosturl;
    NSString * _baseUrl;
}

@property(nonatomic,strong) NSString * hosturl;
@property(nonatomic,strong) NSString * baseUrl;



@end
