//
//  AccountIB.h
//

#import <Foundation/Foundation.h>
#import "BaseService.h"


@interface AccountService : BaseService


//创建用户
- (void)addUserInfoEmail:(NSString *)_email
              collectNum:(NSString *)_number
               firstName:(NSString *)_firstName
                lastName:(NSString *)_lastName
                     pwd:(NSString *)_pwd
              questionId:(NSString *)_questionId
                  answer:(NSString *)_answer;

- (void) validatePassword:(NSString *)_userNAme
                Access_Token:(NSString *)_accessToken andPassword:password;

//获得用户信息
- (void) getUserInformationByUserName:(NSString *)_userNAme
                         Access_Token:(NSString *)_accessToken;

//更新用户
-(void)updateUserInfoFirstName:(NSString*)_firstName
                  LastName:(NSString*)_lastName
                  Address1:(NSString*)_address1
                  Address2:(NSString*)_address2
                      City:(NSString*)_city
                   Province:(NSString*)_province
                    MobilePhone:(NSString*)_mobilePhone;

//修改用户密码
-(void)updateUserPwd:(NSString*)_oldPwd NewPwd:(NSString*)_newPwd;

//用户重置密码
-(void)resetUserPwd:(NSString*)_newPwd;

//解除设备绑定
-(void)deviceRemove_Update;

//通知信息显示
-(void)getNotification;

//通知信息更新
-(void)updateNotification:(NSString*)EmailLoad NotificationLoad:(NSString*)notificationLoad;

//删除通知
-(void)removeNotificationMSGCount;

//添加用户密保问题
- (void) addUserSecurityQuestionByUserName:(NSString *)_userNAme
                              Access_Token:(NSString *)_accessToken
                                questionid:(NSString *)_questionId
                                    answer:(NSString *)_answer;
//获取用户密保问题
- (void) getUserSecurityQuestionByUserName:(NSString *)_userNAme
                              Access_Token:(NSString *)_accessToken;

//获取所有的密保问题
- (void) getAllSecurityQuestion;

//更新用户密保问题
- (void) updateUserSecurityQuestionUserName:(NSString *)_userNAme
                               Access_Token:(NSString *)_accessToken
                             userquestionid:(NSString *)_userId
                                 questionId:(NSString *)_questionId
                                     answer:(NSString *)_answer;
@end
