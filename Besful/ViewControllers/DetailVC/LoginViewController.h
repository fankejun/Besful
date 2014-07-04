//
//  LoginViewController.h
//  Besful
//
//  Created by yzy on 13-11-21.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfo.h"

@interface LoginViewController : BaseViewController <UIAlertViewDelegate>
{
    UITextField * userNameTextField;
    UITextField * passwordTextField;
    UIActivityIndicatorView * loginActivity;
    
    UserInfo * userInfo;
}
@end
