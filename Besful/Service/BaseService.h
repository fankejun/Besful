//
//  BaseService.h
//  
//

#import <Foundation/Foundation.h>
#import "MMHttpRequest.h"
#import "Utility.h"
#import "ErrorResponseBean.h"
#import "RequestHelper.h"
@class CXMLDocument;


@protocol ServiceDelegete <NSObject>

/**返回的数据,如果是采用ASII POST 请求
 *返回一个过滤了异常的XML
 *采用 系统库类 对解析xml
 **/
-(void)setupDataSourceOnASIIByArray:(NSArray*)objArra CloReqTag:(NSInteger) tag;
-(void)setupDataSourceNull:(NSInteger)tag;
/*
 *用于当前ClassName为空的情况
 */
-(void)setupDataSourceXML:( CXMLDocument *)objxml CloReqTag:(NSInteger) tag;

/*
 *用于当前服务器返回了错误信息
 */
-(void)setupDataSourceErrorResponseBean:( ErrorResponseBean *)errorBean CloReqTag:(NSInteger) tag;
/**
 *当请求网络失败后
 **/
-(void)requestFailed:(NSString*)responseErr tags:(NSInteger)tag className:(NSString *)className metodName:(NSString *)methodName;

@end

@interface BaseService : NSObject<MMRequestDelegete>
{

    //请求
    MMHttpRequest *mmRequest;
    Utility *utility;//弹出对话框
    RequestHelper * reqHelper;
    id<ServiceDelegete> serviceDelegete;
    
    NSString * _methodName;
}

@property (nonatomic, strong) MMHttpRequest *mmRequest;
@property (nonatomic, strong) Utility *utility;
@property (nonatomic, strong) RequestHelper * reqHelper;
@property (nonatomic, strong) id<ServiceDelegete> serviceDelegete;


-(void)cleanServiceDelegete;

- (id) initWithDelegate:(id)delegete;


@end
