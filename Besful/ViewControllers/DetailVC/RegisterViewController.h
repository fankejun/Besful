//
//  RegisterViewController.h
//  Besful
//
//  Created by yzy on 13-11-21.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
{
    UITextField * EmailTextField;
    UITextField * passwordTextField;
    UITextField * resetPasswordTextField;
    UITextField * nickNameTextField;
    UITextField * yearFild;
    UITextField * monthField;
    UITextField * dayField;
    
    UIActivityIndicatorView * registerActivity;
}
@end
