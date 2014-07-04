//
//  HttpRequest.m
//  ASITest
//
//  Created by niko on 12-5-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpRequest.h"
#import "Reachability.h"

@implementation HttpRequest
@synthesize urlAddress;
@synthesize asynchronous;
@synthesize isPost;
@synthesize isUseCache;
@synthesize error;
@synthesize response;
@synthesize nsdParam;
@synthesize nsdFile;
@synthesize cachePath;
@synthesize myCache;
@synthesize isOnlyUseCache;
@synthesize cacheTime;
@synthesize responseData;
@synthesize tag;
@synthesize cacheDictionaryPath;
@synthesize timeout;
@synthesize requestDelegete;
@synthesize className;

//-(void)dealloc{
//    
//    asiFormRequest.delegate = nil;
//    asiRequest.delegate = nil;
//    
//    [asiRequest release];
//    [asiFormRequest release];
//    
//    [super dealloc];
//}

- (id)init
{
    if (self = [super init]) {
        // Initialization code here.
        // 设置同步默认值
        [self setAsynchronous: YES];
        [self setIsPost: NO];
        [self setIsUseCache:NO];
        [self setCacheTime:CAHCE_TIME];
        [self setCachePath:[self getCachePath]];
        [self setTimeout:TIME_OUT];
        //        [self performSelector:@selector(checkCacheDir)];
    }
    return self;
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
    
    asiRequest = [ASIHTTPRequest requestWithURL: url];
    
    [self setCache];
    
    [asiRequest setDelegate:self];
    [asiRequest setResponseEncoding:DEFAULT_CHARSET];
    [asiRequest setTimeOutSeconds:timeout];
    [asiRequest startSynchronous];
    
    [self setError: [[[asiRequest error]userInfo] description] ]; // 将NSError 转成字符串
    
    if( !error ){
        self.response = [asiRequest responseString];
        self.responseData = [asiRequest responseData];
    }
    
}

// 异步请求
-(void) sendAsynchro{
    
    NSURL *url = [NSURL URLWithString: [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    asiRequest = [ASIHTTPRequest requestWithURL: url];
    [asiRequest setResponseEncoding :NSUTF8StringEncoding];
    [self setCache];
    [asiRequest setTimeOutSeconds:timeout];
    [asiRequest setDelegate: self];
    [asiRequest startAsynchronous];
  
}

-(void)requestFinished: (ASIHTTPRequest *)request{
    
    [request setResponseEncoding:DEFAULT_CHARSET];
    
    if ([request didUseCachedResponse]) {
         NSLog(@"==YES");
    } else {
         NSLog(@"==NO2");
    }
   
    self.response = [request responseString];
    self.responseData = [asiRequest responseData];
   // [self.requestDelegete requestsucc:self.response tags:self.tag className:self.className];
}

-(void) requestFailed: (ASIHTTPRequest *)request{
    [request setResponseEncoding:DEFAULT_CHARSET];
    [self setError: [[[request error]userInfo] description] ];
   // [self.requestDelegete requestfail:self.error tags:self.tag className:self.className];
}

// 表单提交
-(void) submit{
    
    if( isPost ){
        
        NSURL *url = [NSURL URLWithString: [urlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        asiFormRequest = [ASIFormDataRequest requestWithURL: url];
        
        if (isOnlyUseCache) {
            
            [asiFormRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
            
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            [cache setStoragePath:cachePath];
            
            [self setMyCache:cache];
            [asiFormRequest setDownloadCache:myCache];
            
            [cache release];

        } else {
            
            if (isUseCache) {
                
                
                ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
                [cache setStoragePath:cachePath];
                
                [self setMyCache:cache];
                
                [asiFormRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
                [asiFormRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [asiFormRequest setDownloadCache:myCache];
                [asiFormRequest setResponseEncoding:NSUTF8StringEncoding];
                [asiFormRequest setSecondsToCache:cacheTime];
                
                [cache release];
                
            } else {
                ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
                [cache setStoragePath:cachePath];
                
                [self setMyCache:cache];
                
                [asiFormRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
                [asiFormRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [asiFormRequest setDownloadCache:myCache];
                [asiFormRequest setResponseEncoding:NSUTF8StringEncoding];
                [asiFormRequest setSecondsToCache:cacheTime];
                
                [cache release];
            }
            
        }
        [self addParamToForm];
        [self addFileToForm];
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
    return  [encodedValue autorelease];
}

// 设置将要提交的参数
-(void) addParamToForm{
    for (NSString *keys in nsdParam) {
        [asiFormRequest  setPostValue:[nsdParam objectForKey: keys] forKey: keys];
    }
}

// 设置将要提交的文件
-(void) addFileToForm{
    for (NSString *keys in nsdFile) {
        id filePath = [nsdFile objectForKey: keys];
        if( [filePath isKindOfClass: [NSString class]] ){
            // 传入的是一个文件路径 
            [asiFormRequest  setFile: filePath forKey: keys];
        }else if( [filePath isKindOfClass:[NSData class]] ){
            // 传入的是一个NSData
            [asiFormRequest addData:filePath forKey: keys];
        }
    }
    [self setIsPost: YES];
}

-(void)checkCacheDir{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"ASI_CACHE/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    cachePath = [NSString stringWithString:savedImagePath];         //缓存到本地documents
    
    if ([fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"YES=%@",cachePath);
    } else {
        NSLog(@"NO=%@",cachePath);

    }

}

-(void)setCache{
    
    if (isOnlyUseCache) {
        
        ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
        [cache setStoragePath:cachePath];
        
        [self setMyCache:cache];
        [asiRequest setDownloadCache:myCache];
        [asiRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
        
        [cache release];
        
    } else {
        
        if (isUseCache) {
            
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            [cache setStoragePath:cachePath];
            
            [self setMyCache:cache];
            [asiRequest setDownloadCache:myCache];
            
            [asiRequest setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [asiRequest setDownloadCache:myCache];
            [asiRequest setSecondsToCache:cacheTime];
            
            [cache release];
            
        } else {
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            [cache setStoragePath:cachePath];
            
            [self setMyCache:cache];
            [asiRequest setDownloadCache:myCache];
            
            [asiRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
            [asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [asiRequest setDownloadCache:myCache];
            [asiRequest setSecondsToCache:cacheTime];
            
            [cache release];
            
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
    NSString *folderPath = self.cachePath;
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
    
    if(self.cacheDictionaryPath){
        path = [path stringByAppendingFormat:@"%@/",self.cacheDictionaryPath];
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
    return [fm removeItemAtPath:cachePath error:nil];
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
@end
