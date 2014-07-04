//
//  HttpViewController.h
//  mediator
//
//  Created by Cedric on 12-9-13.
//  Copyright (c) 2012年 Cedric.Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "CheckNetwork.h"

// 定义默认编码格式为utf8
#define DEFAULT_CHARSET 4
#define CAHCE_TIME 60*60*24
#define TIME_OUT 30

@interface HttpViewController : UIViewController<ASIHTTPRequestDelegate>
{

    NSString *urlAddress;     // http request with url
    NSString *hCachePath;
    BOOL asynchronous;        // http request is use asynchronous(异步请求, 默认为YES  NO使用同步)
    BOOL isPost;
    BOOL isUseCache;          //是否使用缓存
    BOOL isOnlyUseCache;      //是否总是使用缓存 适用于无网络情况
    
    NSString *hError;
    NSString *hResponse;
    NSString *hCacheDictionaryPath;
    NSString *hClassName;
    
    NSDictionary *nsdParam;
    NSDictionary *nsdFile;
    
    NSData *responseData;
    int cacheTime;
    int hTag;
    int timeout;
    NSMutableDictionary *classNameDic;

    
    NSMutableArray *centerReqArr;
    
}
@property(nonatomic, retain) NSString *urlAddress;
@property BOOL asynchronous;
@property BOOL isPost;
@property BOOL isUseCache;
@property BOOL isOnlyUseCache;
@property(nonatomic, retain) NSString *hCacheDictionaryPath;
@property(nonatomic, retain) NSString *hError;
@property(nonatomic, retain) NSString *hResponse;
@property(nonatomic, retain) NSString *hCachePath;
@property(nonatomic, retain) NSString *hClassName;
@property(nonatomic, retain) NSDictionary *nsdParam;
@property(nonatomic, retain) NSDictionary *nsdFile;
@property(nonatomic, retain) NSData *responseData;
@property(nonatomic, retain) NSMutableDictionary *classNameDic;


@property int cacheTime;
@property int hTag;
@property int timeout;
-(void) send;
-(void) sendSynchro;
-(void) sendAsynchro;
-(void) initHttp:(NSString*) url Tag:(NSInteger)tags IsAsyn:(BOOL)isAsyns IsUseCache:(BOOL) isUseCaches IsPost:(BOOL)isPosts ClassName:(NSString*) clsName;
-(void)requestsucc:(NSData*)ResponseData tags:(NSInteger)tag className:(NSString*) className;
-(void)requestsuccStr:(NSString*)ResponseStr tags:(NSInteger)tag className:(NSString*) className;
-(void)requestfail:(NSString*)ResponseErr tags:(NSInteger)tag className:(NSString*) className ;
-(NSString *) encodeURL: (NSString *) string;

-(void) submit;

-(void) addParamToForm;
//-(void) addFileToForm;

- (NSString*) cacheSizeAtPath;
-(BOOL) cleanCache;
+(BOOL) isNetWork;
@end
