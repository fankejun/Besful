//
//  BaseSingleton.h
//  Frame
//
//  Created by yzy on 13-6-29.
//  Copyright (c) 2013年 yzy. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface BaseSingleton : NSObject
{
    NSInteger     _server_id;
    NSString        * deviceToken;
    NSDictionary    * isAPNSLogin;
}

@property(nonatomic,readonly)NSString   * DeviceIPAdress;
@property(nonatomic,assign)NSInteger      server_id;
@property(nonatomic,strong)NSString     * deviceToken;
@property(nonatomic,strong)NSDictionary * isAPNSLogin;
@property(nonatomic,strong)NSDictionary * interfaceResourceDic;

+ (BaseSingleton *)sharedSingleton;
+ (NSString*)getDeviceIPAdress;

@end
