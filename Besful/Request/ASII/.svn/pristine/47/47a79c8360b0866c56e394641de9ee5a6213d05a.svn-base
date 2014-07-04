//
//  HttpViewController.m
//  mediator
//
//  Created by Cedric on 12-9-13.
//  Copyright (c) 2012年 Cedric.Cheng. All rights reserved.
//

#import "HttpViewController.h"
#import "Reachability.h"

@interface HttpViewController ()

@end

@implementation HttpViewController

@synthesize urlAddress;
@synthesize asynchronous;
@synthesize isPost;
@synthesize isUseCache;
@synthesize hError;
@synthesize hResponse;
@synthesize nsdParam;
@synthesize nsdFile;
@synthesize hCachePath;
@synthesize isOnlyUseCache;
@synthesize cacheTime;
@synthesize responseData;
@synthesize hTag;
@synthesize hCacheDictionaryPath;
@synthesize timeout;

@synthesize hClassName;
@synthesize classNameDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        centerReqArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (id)init
{
    if (self = [super init]) {
        // Initialization code here.
//        // 设置同步默认值
//        [self setAsynchronous: YES];
//        [self setIsPost: NO];
//        [self setIsUseCache:NO];
//        [self setCacheTime:CAHCE_TIME];
//        [self setHCachePath:[self getCachePath]];
//        [self setTimeout:TIME_OUT];
//        //        [self performSelector:@selector(checkCacheDir)];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
    
    for (ASIHTTPRequest *req in centerReqArr)
    {
        if (req != nil)
        {
            [req clearDelegatesAndCancel];
            req = nil;
        }
    }
    
    [centerReqArr removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    classNameDic = [[NSMutableDictionary alloc] init];

}
-(void) initHttp:(NSString*) url Tag:(NSInteger)tags IsAsyn:(BOOL)isAsyns IsUseCache:(BOOL) isUseCaches IsPost:(BOOL)isPosts ClassName:(NSString*) clsName{
    
    [self setAsynchronous: isAsyns];
    [self setUrlAddress:url];
    [self setHTag:tags];
    [self setIsPost: isPosts];
    [self setIsUseCache:isUseCaches];
    [self setCacheTime:CAHCE_TIME];
    [self setHCachePath:[self getCachePath]];
    [self setTimeout:TIME_OUT];
    
    NSLog(@"----%@",[self getCachePath]);
    [self setHClassName:clsName];
    
    if (clsName == nil) {
        if (classNameDic != nil && ![classNameDic objectForKey:[NSString stringWithFormat:@"%d", self.hTag]]) {
            [classNameDic setValue:@"nil"  forKey:[NSString stringWithFormat:@"%d", self.hTag]];
        }
    }else{
        if (classNameDic != nil && ![classNameDic objectForKey:[NSString stringWithFormat:@"%d", self.hTag]]) {
            [classNameDic setValue:self.hClassName  forKey:[NSString stringWithFormat:@"%d", self.hTag]];
        }
        
    }
    
    //[classNameArray setValue:self.hClassName forKey:[NSString stringWithFormat:@"%d", self.hTag]];
}

// 同步请求
-(void) send{
    if( isPost ){
        [self submit];
    }else if( asynchronous ){
        [self sendAsynchro];
    }else{
        [self sendSynchro];
    }
}

// 同步请求
-(void) sendSynchro{
    
    NSURL *url = [NSURL URLWithString: [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL: url];
    [centerReqArr addObject:asiRequest];
    asiRequest.tag = self.hTag;
    [asiRequest setDelegate:self];
    [asiRequest setResponseEncoding:DEFAULT_CHARSET];
    [asiRequest setTimeOutSeconds:timeout];
    [self setCache:asiRequest];
    
    [asiRequest startSynchronous];
    
}

// 异步请求
-(void) sendAsynchro{
    
    NSURL *url = [NSURL URLWithString: [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];     
    
    ASIHTTPRequest *asiRequest =   [ASIHTTPRequest requestWithURL:url];
    [centerReqArr addObject:asiRequest];
    
    [asiRequest setResponseEncoding :NSUTF8StringEncoding];
    [asiRequest setTimeOutSeconds:timeout];
    [asiRequest setDelegate: self];
    asiRequest.tag = self.hTag;

    [self setCache:asiRequest];
    
    [asiRequest startAsynchronous];
    
}

-(void)requestFinished: (ASIHTTPRequest *)request{
    
    [request setResponseEncoding:DEFAULT_CHARSET];
    
    if ([request didUseCachedResponse]) {
        NSLog(@"==YES");
    } else {
        NSLog(@"==NO2");
    }
    
    self.hResponse = [request responseString];
    NSLog(@"self.hResponse=%@",self.hResponse);
//    self.responseData = [request responseData];
    
//    [self.requestDelegete requestsucc:self.response tags:self.tag className:self.className];
    
    if ([[classNameDic objectForKey:[NSString stringWithFormat:@"%d",request.tag]] isEqualToString:@"nil"]) {
        [self requestsucc:[request responseData] tags:request.tag className:nil];
    } else {
        
        if ([@"0000" isEqualToString:self.hResponse]) {
            [self requestsuccStr:self.hResponse tags:request.tag className:[classNameDic objectForKey:[NSString stringWithFormat:@"%d",request.tag]]];
        }else {
            NSLog(@"hResponse===%@",[request responseString]);
            [self requestsucc:[request responseData] tags:request.tag className:[classNameDic objectForKey:[NSString stringWithFormat:@"%d",request.tag]]];
        }
        
    }
    [request clearDelegatesAndCancel];
}

-(void) requestFailed: (ASIHTTPRequest *)request{
    NSLog(@"[request url]==%@",[request url]);
    [request setResponseEncoding:DEFAULT_CHARSET];
    [self setHError: [[[request error]userInfo] description] ];
//    [self.requestDelegete requestfail:self.error tags:self.tag className:self.className];
    [self requestfail:self.hError tags:request.tag className:self.hClassName];
    [request clearDelegatesAndCancel];
}
-(void)requestsucc:(NSData*)ResponseData tags:(NSInteger)tag className:(NSString*) className{}
-(void)requestsuccStr:(NSString*)ResponseStr tags:(NSInteger)tag className:(NSString*) className{}
-(void)requestfail:(NSString*)ResponseErr tags:(NSInteger)tag className:(NSString*) className{}

// 表单提交
-(void) submit{
    
    if( isPost ){
        
        NSURL *url = [NSURL URLWithString: [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIFormDataRequest *asiFormRequest = [ASIFormDataRequest requestWithURL: url];
        
            
        [asiFormRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];

        for (NSString *keys in nsdParam) {
            [asiFormRequest  setPostValue:[nsdParam objectForKey: keys] forKey: keys];
        }
        [asiFormRequest setTag:self.hTag];
//        [self addFileToForm];
        [asiFormRequest setDelegate: self];
        [asiFormRequest setTimeOutSeconds:timeout];
        [asiFormRequest startSynchronous];
        
    }else{
        [self setIsPost: NO];
        [self send];
    }
}


-(void) setNsdParam:(NSDictionary *)ndParam{
    if( !isPost ){
        NSString *extUrl = nil;
        // 组合 查询字符串
        for (NSString *keys in ndParam) {
            NSString *value = [self encodeURL:[ndParam objectForKey:keys]];
            
            if( extUrl == nil || !extUrl || [extUrl length] == 0 ){
                extUrl = [NSString stringWithFormat:@"?%@=%@", keys, value];
            }else{
                extUrl = [NSString stringWithFormat:@"%@&%@=%@", extUrl, keys, value];
            }
        }
        [self setUrlAddress:[NSString stringWithFormat:@"%@%@", urlAddress, extUrl]];
        nsdParam = nil;
    }else{
        nsdParam = ndParam;
    }
}

//  url 地址编码   ?p1=afs&p2=efef&p3=ekfek
-(NSString *) encodeURL: (NSString *) string{
    NSString *encodedValue = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)string, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return  encodedValue;
}

// 设置将要提交的参数
-(void) addParamToForm{
  
}

// 设置将要提交的文件
//-(void) addFileToForm{
//    for (NSString *keys in nsdFile) {
//        id filePath = [nsdFile objectForKey: keys];
//        if( [filePath isKindOfClass: [NSString class]] ){
//            // 传入的是一个文件路径
//            [asiFormRequest  setFile: filePath forKey: keys];
//        }else if( [filePath isKindOfClass:[NSData class]] ){
//            // 传入的是一个NSData
//            [asiFormRequest addData:filePath forKey: keys];
//        }
//    }
//    [self setIsPost: YES];
//}

-(void)checkCacheDir{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"ASI_CACHE/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //    cachePath = [NSString stringWithString:savedImagePath];         //缓存到本地documents
    
    if ([fileManager createDirectoryAtPath:hCachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"YES=%@",hCachePath);
    } else {
        NSLog(@"NO=%@",hCachePath);
        
    }
    
}

-(void)setCache:(ASIHTTPRequest*)asiRequest{
    
    if (![CheckNetwork isExistenceNetwork]) {
        isOnlyUseCache = YES;
    }
    if (isOnlyUseCache) {
        
        ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
        [cache setStoragePath:hCachePath];
        NSLog(@"%@",[cache storagePath]);
        [asiRequest setDownloadCache:cache];
        [asiRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        
//        [cache release];
        
    } else {
        
        if (isUseCache) {
            
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            [cache setStoragePath:hCachePath];
             NSLog(@"%@",[cache storagePath]);
            [asiRequest setDownloadCache:cache];
            [asiRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [asiRequest setSecondsToCache:cacheTime];

//            [cache release];
            
        } else {
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            [cache setStoragePath:hCachePath];
             NSLog(@"%@",[cache storagePath]);
            [asiRequest setDownloadCache:cache];
            
            [asiRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
            [asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [asiRequest setSecondsToCache:cacheTime];
            [asiRequest setDownloadCache:cache];

//            [cache release];
            
        }
        
    }
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 循环调用fileSizeAtPath来获取一个目录所占空间大小
- (NSString*) cacheSizeAtPath{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"ASI_CACHE/"];
    
    //    NSString *folderPath = [NSString stringWithString:savedImagePath];
    
    NSString *folderPath = [self getCachePath];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    CGFloat value = (float)folderSize;
    if ( folderSize > 1024 * 1024) {
        value = value / (1024 * 1024);
        return [NSString stringWithFormat:@"%.2f M",value];
    }
    else{
        value = value / 1024  ;
        return [NSString stringWithFormat:@"%.2f K",value];
    }
    return nil;
}

-(NSString *)getCachePath{
    
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSString *path = [documentsDirectory stringByAppendingFormat:@"/Cache/"];
    //    if (![fileManager fileExistsAtPath:path]) {
    //        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    //    }
    
    if(self.hCacheDictionaryPath){
        path = [path stringByAppendingFormat:@"%@/",self.hCacheDictionaryPath];
        //        if (![fileManager fileExistsAtPath:path]) {
        //            [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
        //        }
    }
    return path;
    
}

-(BOOL)cleanCache{
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"ASI_CACHE/"];
    
    //    NSString *cacheDirPath = [NSString stringWithString:savedImagePath];
    //    NSString *cacheDirPath = self cacheSizeAtPath
    NSFileManager *fm=[NSFileManager defaultManager];
    return [fm removeItemAtPath:[self getCachePath] error:nil];
}
+(BOOL)isNetWork{
    BOOL reachability = NO;
    Reachability *reach = [Reachability reachabilityWithHostName:@"192.168.3.1"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            //无网络连接
            reachability = NO;
            return reachability;
            break;
        case ReachableViaWWAN:
            //使用3g网络
            reachability = YES;
            return reachability;
            break;
        case ReachableViaWiFi:
            //使用wifi
            reachability = YES;
            return reachability;
            break;
            
        default:
            return reachability;
            break;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
