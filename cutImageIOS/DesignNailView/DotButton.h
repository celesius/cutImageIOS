//
//  DotButton.h
//  cutImageIOS
//
//  Created by vk on 15/9/28.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface DotButton : UIButton
@interface DotButton : UIView
//+(instancetype) initWithFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor*) buttonColor;
//+(instancetype) initWithFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor*) buttonColor;
//-(void) setFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor*) buttonColor andDotRadius:(float)dotDadius;
-(id) initWithFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor *)buttonColor andDotRadius:(float)dotDadius;
@property (nonatomic, strong ) UIButton *aButton;
@end
