//
//  UserInformationViewController.m
//  Besful
//
//  Created by fankejun on 13-12-12.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import "UserInformationViewController.h"
#import "UserInfo.h"

@interface UserInformationViewController ()

@end

@implementation UserInformationViewController
@synthesize userInfoItem;

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
	// Do any additional setup after loading the view.
}

-(void)initUI
{
    [self initTopUI];
    //init data
    NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];

    if ([userdefault objectForKey:@"ID"]!=nil)
    {
        emailString=[userdefault objectForKey:@"USEREMAIL"];
        ncString=[userdefault objectForKey:@"NC"];
        DateString=[userdefault objectForKey:@"BIRTHDAY"];
        passwordString=[userdefault objectForKey:@"USERPWD"];
        
        NSArray * tempArr=[DateString componentsSeparatedByString:@"-"];
        year=[tempArr objectAtIndex:0];
        month=[tempArr objectAtIndex:1];
        day=[tempArr objectAtIndex:2];
    }
    else
    {
        emailString=@"";
        ncString=@"";
        passwordString=@"";
        DateString=@"";
        year=@"";
        month=@"";
        day=@"";
    }
    //init head UI
    UIColor * textColor=[UIColor colorWithRed:10/255.0f green:90/255.0f blue:120/255.0f alpha:1.0];
    UILabel * titleBGLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    CGFloat value = 204/255.0f;
    [titleBGLabel setBackgroundColor:[UIColor colorWithRed:value green:value blue:value alpha:1.0]];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 32, 150, 20)];
    [titleLabel setText:@"用户信息"];
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
    [EmailTextField setPlaceholder:emailString];
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
    [passwordTextField setPlaceholder:passwordString];
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:passwordTextField];
    
    UIImageView * underView1=[[UIImageView alloc]initWithImage:underlineImage];
    [underView1 setFrame:CGRectMake(23, passwordTextField.frame.origin.y+passwordTextField.frame.size.height, 320-23*2, 2)];
    [self.view addSubview:underView1];
    
    UILabel * nickNameLable=[[UILabel alloc]initWithFrame:CGRectMake(45, underView1.frame.size.height+underView1.frame.origin.y, 50, 30)];
    [nickNameLable setText:@"昵称:"];
    [nickNameLable setTextAlignment:NSTextAlignmentLeft];
    [nickNameLable setTextColor:textColor];
    [nickNameLable setFont:[UIFont systemFontOfSize:17.0f]];
    [nickNameLable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:nickNameLable];
    
    nickNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(45+nickNameLable.frame.size.width,underView1.frame.size.height+underView1.frame.origin.y+4, 180, 25)];
    [nickNameTextField setPlaceholder:ncString];
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
    [yearFild setPlaceholder:year];
    [yearFild setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:yearFild];
    
    UILabel * yearLable=[[UILabel alloc]initWithFrame:CGRectMake(yearFild.frame.origin.x+yearFild.frame.size.width, underView3.frame.size.height+underView3.frame.origin.y, 20, 30)];
    [yearLable setText:@"年"];
    [yearLable setBackgroundColor:[UIColor clearColor]];
    [yearLable setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:yearLable];
    
    monthField=[[UITextField alloc]initWithFrame:CGRectMake(yearLable.frame.size.width+yearLable.frame.origin.x+10,underView3.frame.size.height+underView3.frame.origin.y+4, 30, 25)];
    [monthField setKeyboardType:UIKeyboardTypeNumberPad];
    [monthField setPlaceholder:month];
    [monthField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:monthField];
    
    UILabel * monthLable=[[UILabel alloc]initWithFrame:CGRectMake(monthField.frame.origin.x+monthField.frame.size.width, underView3.frame.size.height+underView3.frame.origin.y, 20, 30)];
    [monthLable setText:@"月"];
    [monthLable setBackgroundColor:[UIColor clearColor]];
    [monthLable setFont:[UIFont systemFontOfSize:17.0f]];
    [self.view addSubview:monthLable];
    
    dayField=[[UITextField alloc]initWithFrame:CGRectMake(monthLable.frame.size.width+monthLable.frame.origin.x+10,underView3.frame.size.height+underView3.frame.origin.y+4, 30, 25)];
    [dayField setKeyboardType:UIKeyboardTypeNumberPad];
    [dayField setPlaceholder:day];
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
    
    UIButton * logoOutBurron=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [logoOutBurron setTitle:@"注销" forState:UIControlStateNormal];
    [logoOutBurron setFrame:CGRectMake(self.view.frame.size.width/2-50, underView4.frame.size.height+underView4.frame.origin.y+45, 100, 30)];
    [logoOutBurron addTarget:self action:@selector(logoOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoOutBurron];
}

#pragma mark -- logoOut
-(void)logoOut:(UIButton *)sender
{
    UIAlertView * alt=[[UIAlertView alloc]initWithTitle:@"注销Besful" message:@"确定注销?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [alt show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        //删除所有用户信息,并将登陆标记支委NO
        NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"ID"];
        [userDefault removeObjectForKey:@"USEREMAIL"];
        [userDefault removeObjectForKey:@"NC"];
        [userDefault removeObjectForKey:@"BIRTHDAY"];
        [userDefault removeObjectForKey:@""];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [userDefault setBool:NO forKey:@"isLogoIn"];
    }
    else
    {
        return;
    }
}

-(void)navBtnClicked:(UIButton *)sender
{
    switch (sender.tag)
    {
        case BACK_BUTTON_TAG:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case MORE_BUTTON_TAG:
        {
            if (isOperationViewOpen==NO)
            {
                [self addOprationView];
            }
            else
            {
                [self removeOperationView];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
