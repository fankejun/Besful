//
//  RegisterViewController.m
//  Besful
//
//  Created by yzy on 13-11-21.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "RegisterViewController.h"
#import "GDataXMLNode.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initUI];
}

-(void)initUI
{
    [self initTopUI];
    //init head UI
    UIColor * textColor=[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0];
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    CGFloat value = 204/255.0f;
    [titleBGLabel setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:@"用户注册"];
    [titleLabel setTextColor:textColor];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleBGLabel addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:titleBGLabel];
    [bodyBGImageView sendSubviewToBack:titleBGLabel];

    //init other TextField
    UIImage * underlineImage=[UIImage imageNamed:@"register_underLine"];
    
    UILabel *EmailLable=[[UILabel alloc]initWithFrame:CGRectMake(45, 80+bodyBGImageView.frame.origin.y, 60, 30)];
    [EmailLable setText:@"Email:"];
    [EmailLable setTextAlignment:NSTextAlignmentLeft];
    [EmailLable setTextColor:textColor];
    [EmailLable setFont:[UIFont systemFontOfSize:17.0f]];
    [EmailLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:EmailLable];
    
    EmailTextField=[[UITextField alloc]initWithFrame:CGRectMake(45+EmailLable.frame.size.width+2, 85+bodyBGImageView.frame.origin.y, 170, 25)];
    [EmailTextField setPlaceholder:@"请输入您的邮箱地址"];
    [EmailTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:EmailTextField];
    
    UIImageView * underView=[[UIImageView alloc]initWithImage:underlineImage];
    [underView setFrame:CGRectMake(23, EmailTextField.frame.origin.y+EmailTextField.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView];
    
    
    UILabel * pwdLable=[[UILabel alloc]initWithFrame:CGRectMake(45, underView.frame.size.height+underView.frame.origin.y, 50, 30)];
    [pwdLable setText:@"密码:"];
    [pwdLable setTextAlignment:NSTextAlignmentLeft];
    [pwdLable setTextColor:textColor];
    [pwdLable setFont:[UIFont systemFontOfSize:17.0f]];
    [pwdLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:pwdLable];
    
    passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(45+pwdLable.frame.size.width,underView.frame.size.height+underView.frame.origin.y+4, 183, 25)];
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setPlaceholder:@"请输入6位以上字符"];
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:passwordTextField];
    
    UIImageView * underView1=[[UIImageView alloc]initWithImage:underlineImage];
    [underView1 setFrame:CGRectMake(23, passwordTextField.frame.origin.y+passwordTextField.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView1];
    
    
    UILabel * rePwdLable=[[UILabel alloc]initWithFrame:CGRectMake(45, underView1.frame.size.height+underView1.frame.origin.y, 80, 30)];
    [rePwdLable setText:@"确认密码:"];
    [rePwdLable setTextAlignment:NSTextAlignmentLeft];
    [rePwdLable setTextColor:textColor];
    [rePwdLable setFont:[UIFont systemFontOfSize:17.0f]];
    [rePwdLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:rePwdLable];
    
    resetPasswordTextField=[[UITextField alloc]initWithFrame:CGRectMake(45+rePwdLable.frame.size.width,underView1.frame.size.height+underView1.frame.origin.y+4, 155, 25)];
    [resetPasswordTextField setSecureTextEntry:YES];
    [resetPasswordTextField setPlaceholder:@"请输入6位以上字符"];
    [resetPasswordTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:resetPasswordTextField];
    
    UIImageView * underView2=[[UIImageView alloc]initWithImage:underlineImage];
    [underView2 setFrame:CGRectMake(23, resetPasswordTextField.frame.origin.y+resetPasswordTextField.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView2];
    
    
    UILabel * nickNameLable=[[UILabel alloc]initWithFrame:CGRectMake(45, underView2.frame.size.height+underView2.frame.origin.y, 50, 30)];
    [nickNameLable setText:@"昵称:"];
    [nickNameLable setTextAlignment:NSTextAlignmentLeft];
    [nickNameLable setTextColor:textColor];
    [nickNameLable setFont:[UIFont systemFontOfSize:17.0f]];
    [nickNameLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:nickNameLable];
    
    nickNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(45+nickNameLable.frame.size.width,underView2.frame.size.height+underView2.frame.origin.y+4, 180, 25)];
    [nickNameTextField setPlaceholder:@"请输入您的昵称"];
    [nickNameTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:nickNameTextField];
    
    UIImageView * underView3=[[UIImageView alloc]initWithImage:underlineImage];
    [underView3 setFrame:CGRectMake(23, nickNameTextField.frame.origin.y+nickNameTextField.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView3];
    
    UILabel * brithdayLable=[[UILabel alloc]initWithFrame:CGRectMake(45, underView3.frame.size.height+underView3.frame.origin.y, 50, 30)];
    [brithdayLable setText:@"生日:"];
    [brithdayLable setTextAlignment:NSTextAlignmentLeft];
    [brithdayLable setTextColor:textColor];
    [brithdayLable setFont:[UIFont systemFontOfSize:17.0f]];
    [brithdayLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:brithdayLable];
    
    yearFild=[[UITextField alloc]initWithFrame:CGRectMake(45+brithdayLable.frame.size.width,underView3.frame.size.height+underView3.frame.origin.y+4, 44, 25)];
    [yearFild setKeyboardType:UIKeyboardTypeNumberPad];
    [yearFild setPlaceholder:@"年份"];
    [yearFild setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:yearFild];
    
    UILabel * yearLable=[[UILabel alloc]initWithFrame:CGRectMake(yearFild.frame.origin.x+yearFild.frame.size.width, underView3.frame.size.height+underView3.frame.origin.y, 20, 30)];
    [yearLable setText:@"年"];
    [yearLable setBackgroundColor:[UIColor clearColor]];
    [yearLable setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:yearLable];
    
    monthField=[[UITextField alloc]initWithFrame:CGRectMake(yearLable.frame.size.width+yearLable.frame.origin.x,underView3.frame.size.height+underView3.frame.origin.y+4, 44, 25)];
    [monthField setKeyboardType:UIKeyboardTypeNumberPad];
    [monthField setPlaceholder:@"月份"];
    [monthField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:monthField];
    
    UILabel * monthLable=[[UILabel alloc]initWithFrame:CGRectMake(monthField.frame.origin.x+monthField.frame.size.width, underView3.frame.size.height+underView3.frame.origin.y, 20, 30)];
    [monthLable setText:@"月"];
    [monthLable setBackgroundColor:[UIColor clearColor]];
    [monthLable setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:monthLable];

    dayField=[[UITextField alloc]initWithFrame:CGRectMake(monthLable.frame.size.width+monthLable.frame.origin.x,underView3.frame.size.height+underView3.frame.origin.y+4, 44, 25)];
    [dayField setKeyboardType:UIKeyboardTypeNumberPad];
    [dayField setPlaceholder:@"日期"];
    [dayField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:dayField];
    
    UILabel * dayLable=[[UILabel alloc]initWithFrame:CGRectMake(dayField.frame.origin.x+dayField.frame.size.width, underView3.frame.size.height+underView3.frame.origin.y, 20, 30)];
    [dayLable setText:@"日"];
    [dayLable setBackgroundColor:[UIColor clearColor]];
    [dayLable setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:dayLable];
    
    UIImageView * underView4=[[UIImageView alloc]initWithImage:underlineImage];
    [underView4 setFrame:CGRectMake(23, yearFild.frame.origin.y+yearFild.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView4];
    
    UILabel * welcomlable=[[UILabel alloc]initWithFrame:CGRectMake(50, underView4.frame.size.height+underView4.frame.origin.y+35, 250, 25)];
    [welcomlable setText:@"欢迎您注册Besful手机客户端账号!"];
    [welcomlable setBackgroundColor:[UIColor clearColor]];
    [welcomlable setFont:[UIFont systemFontOfSize:13.0f]];
    [self.view addSubview:welcomlable];
    
    UIImage * pressImage=[UIImage imageNamed:@"register_Press"];
    UIImage * unPressImage=[UIImage imageNamed:@"register_unPress"];
    UIButton * registerBurron=[UIButton buttonWithType:UIButtonTypeCustom];
    [registerBurron setFrame:CGRectMake(self.view.frame.size.width/2-50, welcomlable.frame.size.height+welcomlable.frame.origin.y+45, 100, 30)];
    [registerBurron setBackgroundImage:unPressImage forState:UIControlStateNormal];
    [registerBurron setBackgroundImage:pressImage forState:UIControlStateHighlighted];
    [registerBurron addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBurron];
    
    //init activity
    registerActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [registerActivity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [registerActivity setColor:[UIColor blueColor]];
    [self.view addSubview:registerActivity];

}

-(void)goRegister:(UIButton *)sender
{
    NSString * rulDetail=@"UserRegister";
    NSString * year=yearFild.text;
    NSString * month=monthField.text;
    NSString * day=dayField.text;
    NSString * birthday=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSString * username=EmailTextField.text;
    NSString * nc=nickNameTextField.text;
    if (![passwordTextField.text isEqualToString:resetPasswordTextField.text])
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }
    else
    {
        NSString * pwd=resetPasswordTextField.text;
        NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
        ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
        [requestArray addObject:request];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setPostValue:username forKey:@"username"];
        [request setPostValue:pwd forKey:@"pwd"];
        [request setPostValue:nc forKey:@"nc"];
        [request setPostValue:birthday forKey:@"birthday"];
        [request startAsynchronous];
        [registerActivity startAnimating];

    }
}

#pragma mark -- getNetwork
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"[request responseString]====%@",[request responseString]);
    [registerActivity stopAnimating];
    [registerActivity setHidesWhenStopped:YES];
    
    GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
    GDataXMLElement *rootElement = [docuemnt rootElement];
    NSDictionary * arr=[rootElement.stringValue JSONValue];
    NSString * registerResult=[arr valueForKey:@"msg"];
    NSLog(@"%@",registerResult);
    if ([registerResult isEqualToString:@"注册成功"])
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt setTag:REGISTER_SUCCESSFUL];
        [alt show];
    }
    else
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt setTag:REGISTER_FAILURE];
        [alt show];
    }
    
    request.delegate = nil;
    [requestArray removeObject:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestError:%@",request.error);
    [registerActivity stopAnimating];
    [registerActivity setHidesWhenStopped:YES];
    request.delegate = nil;
    [requestArray removeObject:request];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==REGISTER_SUCCESSFUL)
    {
        if (buttonIndex==0)
        {
            //register successful
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag==REGISTER_FAILURE)
    {
        if (buttonIndex==0)
        {
            //register fail do nothing
        }
    }
}

#pragma mark -- when you pressed a blank place,dismiss keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [EmailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [resetPasswordTextField resignFirstResponder];
    [nickNameTextField resignFirstResponder];
    [yearFild resignFirstResponder];
    [monthField resignFirstResponder];
    [dayField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
