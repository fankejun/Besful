//
//  MMHttpRequest.m
//  AriEWallets
//
//  Created by GSL on 13-1-5.
//  Copyright (c) 2013年 Grover.Gong. All rights reserved.
//

#import "MMHttpRequest.h"
#import "BaseSingleton.h"

@implementation MMHttpRequest
@synthesize requestDelegete;
@synthesize asiParams;
@synthesize requestHeader;
@synthesize className;
@synthesize methodName;

//初始化请求
/**
 *param tags:请求的标识
 *param urlAdress:请求的url
 *param method:是否是post方式
 *param _className:Model中某一个类的类名（XML解析的时候用到）
 *param _methodName:请求参数中的具体接口名称（如userInfo.get）
 **/
-(id)initMMRequest:(int)tags url:(NSString*)urlAdress reqPostMethod:(BOOL)method className:(NSString *)_className metodName:(NSString *)_methodName
{
    tag = tags;
    isPost = method;
    timeout = TIME_OUT;
    asiParams = [[NSDictionary alloc]init];
    NSLog(@"methodName==%@",_methodName);
    [self setClassName:_className];
    [self setMethodName:_methodName];
    requestHeader = [[NSMutableDictionary alloc]init];
    
    urlAddress = urlAdress;
    
    return self;
}


// 异步get请求
-(void) sendAsynchro
{
    NSURL *url = [NSURL URLWithString:urlAddress];

    NSLog(@"sendAsynchro get==%@",url);
    asiRequest = [ASIHTTPRequest requestWithURL: url];
    asiRequest.tag = tag;
    [self addRequestHeader];
    [asiRequest setResponseEncoding :NSUTF8StringEncoding];
    [asiRequest setTimeOutSeconds:timeout];
    //为了方便https访问
    [asiRequest setValidatesSecureCertificate:NO];
    //请求失败重试3次
    [asiRequest setNumberOfTimesToRetryOnTimeout:3];
    [asiRequest setDelegate: self];
    [asiRequest startAsynchronous];
    
}

//异步post请求
-(void)submitAsynchro
{
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    asiFormRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    NSLog(@"url==%@",url);
    //增加参数
    if ([asiParams count]>0)
    {
         [self addParamToForm];
    }
    [self addRequestHeader];
    [asiFormRequest setDelegate:self];
     asiFormRequest.tag = tag;
    [asiFormRequest setRequestMethod:@"POST"];
    //为了方便https访问
    [asiFormRequest setValidatesSecureCertificate:NO];
    //请求失败重试3次
    [asiFormRequest setNumberOfTimesToRetryOnTimeout:3];
    //发送请求
    [asiFormRequest setTimeOutSeconds:timeout];
    [asiFormRequest startAsynchronous];
}

// 设置将要提交的参数
-(void) addParamToForm
{
    for (NSString *keys in asiParams)
    {
        [asiFormRequest  setPostValue:[asiParams objectForKey: keys] forKey: keys];
    }
}

//设置请求头
-(void)addRequestHeader
{
    if (isPost)//post
    {
        [asiFormRequest setRequestHeaders:requestHeader];
    }
    else//get
    {
        [asiRequest setRequestHeaders:requestHeader];
    }
}

//开始请求
-(void)startRequest
{
    if (isPost)//post
    {
        [self submitAsynchro];
    
    }
    else//get
    {
        [self sendAsynchro];
    }
}

-(void)requestFinished: (ASIHTTPRequest *)request
{
    //返回编码
    [request setResponseEncoding:DEFAULT_CHARSET];
    //NSLog(@"reponese==%@",[request responseString]);

    //返回结果
    [self.requestDelegete requestSucceed:[request responseString] tags:tag className:className metodName:methodName];
    
    //完成之后。。清理delete
    [request clearDelegatesAndCancel];
}

-(void) requestFailed: (ASIHTTPRequest *)request
{
    //返回编码
    [request setResponseEncoding:DEFAULT_CHARSET];
    NSLog(@"request.responseStatusCode===%d==", request.responseStatusCode);
    //返回
    [self.requestDelegete requestFailed:[[[request error]userInfo] description]  tags:tag className:className metodName:methodName];
    //完成之后。。清理delete
    [request clearDelegatesAndCancel];
}


-(NSString*)URLStringEncode:(NSString *)_urlString
{
//    //特殊字符处理" ","!" "&"...
//    [_urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];//空格
//    //...
//    return nil;
    NSString *result = (NSString*)CFBridgingRelease (CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)_urlString, nil,(CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>{}|\\^~`", kCFStringEncodingUTF8));
    return result;
}



@end
