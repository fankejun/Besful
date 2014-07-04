//
//  ProductDetailViewController.h
//  Besful
//
//  Created by yzy on 13-11-24.
//  Copyright (c) 2013年 com.besful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProductDetailViewController : BaseViewController
{
    UIImageView * topImageView;
    UILabel * EnglishLable;
    UILabel * prodNameLable;
    UILabel * proggLable;
    UILabel * priceLable; //skinLable;
    UILabel * explanationLable;
    UILabel * efficacyLable;
    UIScrollView * imageContentView;
    
    UILabel * tempLable1;
    UILabel * tempLable2;
    UILabel * tempLable3;
    
    NSString * s;
    
    UIFont * font;
    
    UIView * buttomView;
    UIButton * arrowBtn;
    UIImageView * arrowImageView;
    BOOL UP;
    float lableH;
    
    NSMutableArray * prodArray;
    NSMutableArray * prodRelImageArray;
    NSMutableArray * prodListArray;
    UIActivityIndicatorView * activityView;
    UITextView * contentScroll;
    UIColor * textColor1;
    
    CGFloat buttomViewUpY;
    CGFloat buttomViewDownY;
    
    NSString * prodUrl;
    NSString * prodInfo;
    
    UIImage  * noneImage;
}

@property(nonatomic,strong)NSString * prodID;
@end
