//
//  UserInformationViewController.h
//  Besful
//
//  Created by fankejun on 13-12-12.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserInfo.h"

@interface UserInformationViewController :BaseViewController <UIAlertViewDelegate>
{
    UITextField * EmailTextField;
    UITextField * passwordTextField;
    UITextField * nickNameTextField;
    UITextField * yearFild;
    UITextField * monthField;
    UITextField * dayField;
    
    NSString * emailString;
    NSString * passwordString;
    NSString * ncString;
    NSString * DateString;
    
    NSString * year;
    NSString * month;
    NSString * day;
}
@property (strong,nonatomic)UserInfo * userInfoItem;
@end
