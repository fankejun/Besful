//
//  LoginViewController.m
//  Besful
//
//  Created by yzy on 13-11-21.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "LoginViewController.h"
#import "GDataXMLNode.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "RegisterViewController.h"
#import "UserInformationViewController.h"
#import "UserInfo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    CGFloat value = 204/255.0f;
    [titleBGLabel setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:@"用户登录"];
    [titleLabel setTextColor:[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleBGLabel addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [bodyBGImageView addSubview:titleBGLabel];
    [bodyBGImageView sendSubviewToBack:titleBGLabel];
    
    
    //user name
    UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, 90, 20)];
    [userNameLabel setText:@"邮箱："];
    [userNameLabel setTextColor:titleLabel.textColor];
    [userNameLabel setFont:[UIFont systemFontOfSize:17]];
    [userNameLabel setTextAlignment:NSTextAlignmentRight];
    [bodyBGImageView addSubview:userNameLabel];
    
    UIImageView * virtualBorder1 = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLabel.frame.origin.x+userNameLabel.frame.size.width, userNameLabel.frame.origin.y, 320-userNameLabel.frame.size.width-userNameLabel.frame.origin.x-15, 20)];
    [virtualBorder1 setImage:[UIImage imageNamed:@"virtualBorder"]];
    [bodyBGImageView addSubview:virtualBorder1];
    
    userNameTextField = [[UITextField alloc] initWithFrame:virtualBorder1.frame];
    [userNameTextField setDelegate:self];
    [bodyBGImageView addSubview:userNameTextField];
    
    
    //password
    UILabel * passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userNameLabel.frame.origin.y+userNameLabel.frame.size.height+15, 90, 20)];
    [passwordLabel setText:@"密码："];
    [passwordLabel setTextColor:titleLabel.textColor];
    [passwordLabel setFont:[UIFont systemFontOfSize:17]];
    [passwordLabel setTextAlignment:NSTextAlignmentRight];
    [bodyBGImageView addSubview:passwordLabel];
    
    UIImageView * virtualBorder2 = [[UIImageView alloc] initWithFrame:CGRectMake(passwordLabel.frame.origin.x+passwordLabel.frame.size.width, passwordLabel.frame.origin.y, 320-passwordLabel.frame.size.width-passwordLabel.frame.origin.x-15, 20)];
    [virtualBorder2 setImage:[UIImage imageNamed:@"virtualBorder"]];
    [bodyBGImageView addSubview:virtualBorder2];
    
    passwordTextField = [[UITextField alloc] initWithFrame:virtualBorder2.frame];
    [passwordTextField setDelegate:self];
    [passwordTextField setSecureTextEntry:YES];
    [bodyBGImageView addSubview:passwordTextField];
    
    
    //login button
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(110, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+30, 100, 30)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btnBG_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btnBG_highlighted"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(getInfo:) forControlEvents:UIControlEventTouchUpInside];
    [bodyBGImageView addSubview:loginBtn];
    
    //link:goto register page or goto forgot password page
    UILabel * registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, loginBtn.frame.origin.y+loginBtn.frame.size.height+35, 320, 30)];
    [registerLabel setText:@"注册新用户"];
    [registerLabel setTextColor:[UIColor colorWithRed:56/255.0f green:176/255.0f blue:235/255.0f alpha:1.0]];
    [registerLabel setTextAlignment:NSTextAlignmentCenter];
    [bodyBGImageView addSubview:registerLabel];
    
    UIImageView * lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(88, registerLabel.frame.origin.y+registerLabel.frame.size.height, 144, 2)];
    UIImage * underLineImage = [UIImage imageNamed:@"underLine"];
    [lineImageView1 setImage:underLineImage];
    [bodyBGImageView addSubview:lineImageView1];
    UIButton * clickBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn1 addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = registerLabel.frame;
    frame.origin.x = lineImageView1.frame.origin.x;
    frame.origin.y -= 3;
    frame.size.height += 6;
    frame.size.width = lineImageView1.frame.size.width;
    [clickBtn1 setFrame:frame];
    [clickBtn1 setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:clickBtn1];
    
    UILabel * forgotPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lineImageView1.frame.origin.y+lineImageView1.frame.size.height+20, 320, 30)];
    [forgotPasswordLabel setText:@"找回密码"];
    [forgotPasswordLabel setTextColor:[UIColor colorWithRed:56/255.0f green:176/255.0f blue:235/255.0f alpha:1.0]];
    [forgotPasswordLabel setTextAlignment:NSTextAlignmentCenter];
    [bodyBGImageView addSubview:forgotPasswordLabel];
    
    UIImageView * lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(88, forgotPasswordLabel.frame.origin.y+forgotPasswordLabel.frame.size.height, 144, 2)];
    [lineImageView2 setImage:underLineImage];
    [bodyBGImageView addSubview:lineImageView2];
    UIButton * clickBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    frame = forgotPasswordLabel.frame;
    frame.origin.x = lineImageView2.frame.origin.x;
    frame.origin.y -= 3;
    frame.size.height += 6;
    frame.size.width = lineImageView2.frame.size.width;
    [clickBtn2 setFrame:frame];
    [clickBtn2 setBackgroundColor:[UIColor clearColor]];
    [bodyBGImageView addSubview:clickBtn2];
    
    //init activity
    loginActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loginActivity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [loginActivity setColor:[UIColor blueColor]];
    [self.view addSubview:loginActivity];
}

#pragma mark -- go RegisterPage
-(void)goRegister:(UIButton *)sender
{
    RegisterViewController * registerCtl=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerCtl animated:YES];
}

#pragma mark -- getNetWork info
-(void)getInfo:(UIButton *)sender
{
    NSString * rulDetail=@"UserLoginCheck";
    NSString * username=userNameTextField.text;
    NSString * pwd=passwordTextField.text;
    if (username==nil||pwd==nil||[username isEqualToString:@""]||[pwd isEqualToString:@""])
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确填写用户名和密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
    }
    else
    {
        NSURL * postUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",web_url,rulDetail]];
        ASIFormDataRequest * request=[ASIFormDataRequest requestWithURL:postUrl];
        [requestArray addObject:request];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setPostValue:username forKey:@"username"];
        [request setPostValue:pwd forKey:@"pwd"];
        [request startAsynchronous];
        [loginActivity startAnimating];
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"[request responseString]====%@",[request responseString]);
    [loginActivity stopAnimating];
    [loginActivity setHidesWhenStopped:YES];
    
    GDataXMLDocument *docuemnt = [[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:1 error:nil];
    GDataXMLElement *rootElement = [docuemnt rootElement];
    NSLog(@"rootElement:%@",rootElement);
    NSDictionary * arr=[rootElement.stringValue JSONValue];
    NSString * loginResult=[arr valueForKey:@"success"];
    NSString * loginError=[arr valueForKey:@"msg"];
    if ([loginResult isEqualToString:@"true"])
    {
        NSArray * resultArray=[arr valueForKey:@"Orders"];
        for (NSDictionary * dic in resultArray)
        {
            userInfo=[self getAnSimpleObject:[UserInfo class] withFromDictionary:dic];
        }
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"登陆Besful" message:@"登录成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt setTag:LOGIN_SUCCESSFUL];
        [alt show];
    }
    else
    {
        UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"登录失败" message:loginError delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt setTag:LOGIN_FAILURE];
        [alt show];
    }
    
    request.delegate = nil;
    [requestArray removeObject:request];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestError:%@",request.error);
    [loginActivity stopAnimating];
    [loginActivity setHidesWhenStopped:YES];
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请求超时" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alt setTag:LOGIN_FAILURE];
    [alt show];
    request.delegate = nil;
    [requestArray removeObject:request];
}

#pragma mark -- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==LOGIN_SUCCESSFUL)
    {
        if (buttonIndex==0)
        {
            //login success go back
            UserInformationViewController * userinfoCtl=[[UserInformationViewController alloc]init];
            NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
            [userdefault setObject:userInfo.ID forKey:@"ID"];
            [userdefault setObject:userInfo.USEREMAIL forKey:@"USEREMAIL"];
            [userdefault setObject:userInfo.USERPWD forKey:@"USERPWD"];
            [userdefault setObject:userInfo.NC forKey:@"NC"];
            [userdefault setObject:userInfo.BIRTHDAY forKey:@"BIRTHDAY"];
            //将登陆标记置为YES
            [userdefault setBool:YES forKey:@"isLogoIn"];
            [self.navigationController pushViewController:userinfoCtl animated:YES];
        }
    }
    if (alertView.tag==LOGIN_FAILURE)
    {
        if (buttonIndex==0)
        {
            //login fail do nothing
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
