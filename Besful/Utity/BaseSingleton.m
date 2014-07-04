//
//  BaseSingleton.h
//  Frame
//
//  Created by yzy on 13-6-29.
//  Copyright (c) 2013年 yzy. All rights reserved.
//

#import "BaseSingleton.h"


@implementation BaseSingleton

static NSString * _DeviceIPAdress;

@synthesize DeviceIPAdress=_DeviceIPAdress;
@synthesize server_id=_server_id;
@synthesize deviceToken=_deviceToken;
@synthesize isAPNSLogin=_isAPNSLogin;
@synthesize interfaceResourceDic;


//全局变量的对象
+ (BaseSingleton *)sharedSingleton{
    static BaseSingleton *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[BaseSingleton alloc] init];
        }
        
        return sharedSingleton;
    }
}

-(NSString*)DeviceIPAdress
{
    return _DeviceIPAdress;
}
+ (NSString*)getDeviceIPAdress
{
    return _DeviceIPAdress;
}





@end
