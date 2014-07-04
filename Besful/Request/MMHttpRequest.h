//
//  MMHttpRequest.h
//  AriEWallets
//
//  Created by GSL on 13-1-5.
//  Copyright (c) 2013年 Grover.Gong. All rights reserved.

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"

// 定义默认编码格式为utf8
#define DEFAULT_CHARSET 4
#define CAHCE_TIME 60*10
#define TIME_OUT 30

@protocol MMRequestDelegete <NSObject>
    -(void)requestSucceed:(NSString*)response tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName;
    -(void)requestFailed:(NSString*)responseErr tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName;
@end

@interface MMHttpRequest : NSObject<ASIHTTPRequestDelegate>{
    
    NSString *urlAddress; 
    NSDictionary *asiParams;
    NSString *className;
    NSString *methodName;
    
    NSMutableDictionary  *requestHeader;
    
    ASIHTTPRequest *asiRequest;
    ASIFormDataRequest *asiFormRequest;     // 表单提交对象
    
    id<MMRequestDelegete> requestDelegete;
    BOOL isPost;
    int tag;
    int timeout;

}

@property(nonatomic, retain) id<MMRequestDelegete> requestDelegete;
@property(nonatomic, strong) NSDictionary *asiParams;
@property(nonatomic, strong) NSMutableDictionary  *requestHeader;
@property(nonatomic, strong)  NSString *className;
@property(nonatomic, strong)  NSString *methodName;

-(id)initMMRequest:(int)tags url:(NSString*)urlAdress reqPostMethod:(BOOL)method className:(NSString *)_className metodName:(NSString *)_methodName;

-(void)startRequest;

@end
