//
//  Utility.m
//

#import "Utility.h"

@implementation MyTransitionAnimationFade


+(void) animation:(NSString *) animationType transView:(UIView*) tView duration:(CFTimeInterval)duration
{
	CATransition *animation = [CATransition animation];
	//动画播放持续时间
	[animation setDuration:duration];
	//动画速度,何时快、慢
	[animation setTimingFunction:[CAMediaTimingFunction 
								  functionWithName:kCAMediaTimingFunctionEaseIn]];
	[animation setType:animationType];
	[animation setSubtype:kCATransitionFromBottom];
	[tView.layer addAnimation:animation forKey:@"Reveal"];
}
@end


@implementation Utility


- (id)init {
    
    if ((self = [super init])) {
        //
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}



-(void) errorAlert:(NSString *)msg title:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}

-(void) errorAlert:(NSString *)msg title:(NSString *)title okBtn:(NSString *)OKbtn 
         cancelBtn:(NSString *)cancelBtn delegate:(id)delegate tag:(int)tag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cancelBtn otherButtonTitles:OKbtn, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];
    [alert release];
}



-(void)phoneCall:(NSString *)theNumber {
	NSString *phoneURL = [NSString stringWithFormat:@"tel:%@", theNumber];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: phoneURL]];	
}


@end



