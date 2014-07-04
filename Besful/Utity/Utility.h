//
//  Utility.h
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#define DURATION_DEFAULT 0.7

@interface MyTransitionAnimationFade:NSObject {
    
}

+(void) animation:(NSString *) animationType transView:(UIView*) tView duration:(CFTimeInterval)duration;

@end


@interface Utility : NSObject

-(void) errorAlert:(NSString *)msg title:(NSString *)title;
-(void) errorAlert:(NSString *)msg title:(NSString *)title okBtn:(NSString *)OKbtn 
         cancelBtn:(NSString *)cancelBtn delegate:(id)delegate tag:(int)tag;



-(void)phoneCall:(NSString *)theNumber;
@end

