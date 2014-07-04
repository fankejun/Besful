//
//  HttpRequest.h
//  ASITest
//
//  Created by niko on 12-5-1.Edit By Cedric on 12-8-28
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

// 定义默认编码格式为utf8
#define DEFAULT_CHARSET 4
#define CAHCE_TIME 60*10
#define TIME_OUT 30

@protocol RequestDelegete <NSObject>
    -(void)requestSucceed:(NSString*)response tags:(NSInteger)tag className:(NSString*) className ;
    -(void)requestFailed:(NSString*)responseErr tags:(NSInteger)tag className:(NSString*) className;

@end
@interface HttpRequest: NSObject<ASIHTTPRequestDelegate>{
    
    NSString *urlAddress;     // http request with url
    NSString *cachePath;
    BOOL asynchronous;        // http request is use asynchronous(异步请求, 默认为YES  NO使用同步)
    BOOL isPost;
    BOOL isUseCache;          //是否使用缓存
    BOOL isOnlyUseCache;      //是否总是使用缓存 适用于无网络情况
    
    ASIHTTPRequest *asiRequest;
    ASIFormDataRequest *asiFormRequest;     // 表单提交对象
    ASIDownloadCache *myCache;
    
    NSString *error;
    NSString *response;
    NSString *cacheDictionaryPath;
    NSString *className;
    
    NSDictionary *nsdParam;
    NSDictionary *nsdFile;
    
    NSData *responseData;
    int cacheTime;
    int tag;
    int timeout;
    
    id<RequestDelegete> requestDelegete;
    
}
@property(nonatomic, retain) NSString *urlAddress;
@property BOOL asynchronous;
@property BOOL isPost;
@property BOOL isUseCache;
@property BOOL isOnlyUseCache;
@property(nonatomic, retain) NSString *cacheDictionaryPath;
@property(nonatomic, retain) NSString *error;
@property(nonatomic, retain) NSString *response;
@property(nonatomic, retain) NSString *cachePath;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) NSDictionary *nsdParam;
@property(nonatomic, retain) NSDictionary *nsdFile;
@property(nonatomic, retain) NSData *responseData;

@property(nonatomic, retain) ASIDownloadCache *myCache;
@property(nonatomic, retain) id<RequestDelegete> requestDelegete;

@property int cacheTime;
@property int tag;
@property int timeout;
-(void) send;
-(void) sendSynchro;
-(void) sendAsynchro;

-(NSString *) encodeURL: (NSString *) string;

-(void) submit;

-(void) addParamToForm;
-(void) addFileToForm;

- (NSString*) cacheSizeAtPath;
-(BOOL) cleanCache;
+(BOOL) isNetWork;
@end
