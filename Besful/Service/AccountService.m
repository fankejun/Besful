//
//  AccountIB.m
//

/**
 *业务层只负责传递参数，不负责网络请求的具体细节
 **/

#import "AccountService.h"
#import "BaseSingleton.h"


@implementation AccountService

- (void)addUserInfoEmail:(NSString *)_email
              collectNum:(NSString *)_number
               firstName:(NSString *)_firstName
                lastName:(NSString *)_lastName
                     pwd:(NSString *)_pwd
              questionId:(NSString *)_questionId
                  answer:(NSString *)_answer

{
    NSString * methodName=@"userinfo.Add";
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    
    [param setObject:_email forKey:@"email"];
    [param setObject:_number forKey:@"collectornumber"];
    [param setObject:_firstName forKey:@"firstname"];
    [param setObject:_lastName forKey:@"lastname"];
    [param setObject:_pwd forKey:@"pwd"];
    [param setObject:_questionId forKey:@"questionid"];
    [param setObject:_answer forKey:@"answer"];
    [param setObject:timeString forKey:@"timestamp"];
    [param setObject:methodName forKey:@"method"];
    
    
    NSString * addUserBaseUrl = reqHelper.baseUrl;
    NSLog(@"addUserBaseUrl:%@",addUserBaseUrl);
    mmRequest = [[MMHttpRequest alloc] initMMRequest:ADDUSERINFO url:addUserBaseUrl reqPostMethod:YES className:nil metodName:methodName];
    mmRequest.asiParams=param;
//    NSMutableDictionary * headerParam=[[NSMutableDictionary alloc]init];
//    headerParam=param;
//    [mmRequest setRequestHeader:headerParam];
    mmRequest.requestDelegete = self;
    [mmRequest startRequest];
}

//获得用户信息
- (void) getUserInformationByUserName:(NSString *)_userNAme
                         Access_Token:(NSString *)_accessToken
{
    NSString * methodName=@"userinfo.Get";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    [param setObject:_userNAme forKey:@"username"];
    [param setObject:_accessToken forKey:@"Access_Token"];
    [param setObject:methodName forKey:@"method"];
    
    NSString * getUserInformationBaseUrl =reqHelper.baseUrl;
    NSLog(@"getUserInformationBaseUrl:%@",getUserInformationBaseUrl);
    mmRequest =[[MMHttpRequest alloc]initMMRequest:GETUSERINFOINFORMATION url:getUserInformationBaseUrl reqPostMethod:NO className:@"UserInformation" metodName:methodName];
//    NSMutableDictionary *headerparam = [[NSMutableDictionary alloc]init];
//    headerparam = param;
//    [mmRequest setRequestHeader:headerparam];
    
    mmRequest.requestDelegete = self;
    [mmRequest startRequest];
}

- (void) validatePassword:(NSString *)_userNAme
                Access_Token:(NSString *)_accessToken andPassword:password
{
    
}


//更新用户
-(void)updateUserInfoFirstName:(NSString*)_firstName
                      LastName:(NSString*)_lastName
                      Address1:(NSString*)_address1
                      Address2:(NSString*)_address2
                          City:(NSString*)_city
                      Province:(NSString*)_province
                   MobilePhone:(NSString*)_mobilePhone
{
    
}

//修改用户密码
-(void)updateUserPwd:(NSString*)_oldPwd NewPwd:(NSString*)_newPwd
{
    
}

//用户重置密码
-(void)resetUserPwd:(NSString*)_newPwd
{
    
}

//解除设备绑定
-(void)deviceRemove_Update
{
    
}

//通知信息显示
-(void)getNotification
{
    
}

//通知信息更新
-(void)updateNotification:(NSString*)EmailLoad NotificationLoad:(NSString*)notificationLoad
{
    
}

//删除通知
-(void)removeNotificationMSGCount
{
    
}

//添加用户密保问题
- (void) addUserSecurityQuestionByUserName:(NSString *)_userNAme
                              Access_Token:(NSString *)_accessToken
                                questionid:(NSString *)_questionId
                                    answer:(NSString *)_answer
{
    
}
//获取用户密保问题
- (void) getUserSecurityQuestionByUserName:(NSString *)_userNAme
                              Access_Token:(NSString *)_accessToken
{
    
}

//获取所有的密保问题
- (void) getAllSecurityQuestion
{
    
}

//更新用户密保问题
- (void) updateUserSecurityQuestionUserName:(NSString *)_userNAme
                               Access_Token:(NSString *)_accessToken
                             userquestionid:(NSString *)_userId
                                 questionId:(NSString *)_questionId
                                     answer:(NSString *)_answer
{
    
}


@end
