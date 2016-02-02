//
//  DotButton.m
//  cutImageIOS
//  建立一个点按键，每个按键是一个圆点，用于表示画笔的变化，每个按键都与画笔宽度相同
//  Created by vk on 15/9/28.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "DotButton.h"
#import "FXBlurView.h"

@interface DotButton()

@property (nonatomic, strong) FXBlurView *buttonView;

@end


@implementation DotButton

-(id) initWithFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor *)buttonColor andDotRadius:(float)dotDadius{
    if (self = [super initWithFrame:frame]) {
        self.aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setFrame:frame andCentre:centrePoint andColor:buttonColor andDotRadius:dotDadius];
    }
    return self;
}

-(void) setFrame:(CGRect)frame andCentre:(CGPoint)centrePoint andColor:(UIColor *)buttonColor andDotRadius:(float)dotDadius
{
    self.center = centrePoint;
    [self.layer setCornerRadius:frame.size.width/2];
    self.buttonView = [[FXBlurView alloc]initWithFrame: CGRectMake(0, 0, dotDadius*2, dotDadius*2) ];
    self.buttonView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.buttonView.layer setCornerRadius:dotDadius];
    self.buttonView.backgroundColor = buttonColor;
    self.buttonView.blurRadius = 40;
    [self addSubview:self.buttonView];
    
    /*
    int value = arc4random()%100;
    float red = (float)value/100.0;
    value = arc4random()%100;
    float green = (float)value/100.0;
    value = arc4random()%100;
    float blue = (float)value/100.0;
    self.aButton.backgroundColor =[UIColor colorWithRed:red green:green blue:blue alpha:0.4];
    */
    
    self.aButton.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.aButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
