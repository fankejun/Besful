//
//  ErrorResponseBean.h
//  
//

#import <Foundation/Foundation.h>

@interface ErrorResponseBean : NSObject{

    NSString *code;
    NSString *msg;
    NSString *sub_code;
    NSString *sub_msg;
}

@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic, strong) NSString *sub_code;
@property(nonatomic, strong) NSString *sub_msg;



@end
