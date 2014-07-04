//
//  BaseService.m
// 
//

#import "BaseService.h"
#import "BaseViewController.h"
#import "BaseSingleton.h"

NSString *dynamic ;
@implementation BaseService

@synthesize mmRequest;
@synthesize utility;
@synthesize reqHelper;
@synthesize serviceDelegete;

- (id) initWithDelegate:(id)delegete
{
    self = [super init];
    if (self)
    {
        //初始化请网络请求
        self.utility =  [[Utility alloc] init];
        self.serviceDelegete = delegete;
        reqHelper=[[RequestHelper alloc] init];
        dynamic = [[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicKey"];
    }
    return self;
}
-(void)cleanServiceDelegete
{
    self.serviceDelegete = nil;
}


#pragma mark MMRequestDelegete
//网络请求返回成功
-(void)requestSucceed:(NSString*)response tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName
{
    NSLog(@"requestsucc==response==%@",response);

    
    
     mmRequest.requestDelegete = nil;
    [self setServiceDelegete:nil];
}

#pragma mark MMRequestDelegete
//网络请求失败
-(void)requestFailed:(NSString*)responseErr tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName
{
    NSLog(@"requestfail==response=base=%@",responseErr);
    [self.utility errorAlert:@"Network or server request timeout. Please try again!" title:@"system prompt"];
    
     mmRequest.requestDelegete = nil;
    [self.serviceDelegete requestFailed:responseErr tags:tag className:className metodName:methodName];
    [self setServiceDelegete:nil];
}


@end
