//
//  ColorBoardView.h
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "DynamicView.h"
#import "DynamicBlurView.h"

@interface ColorBoardView : DynamicView

-(id)initWithRect:(CGRect)viewRect andHiddenPoint:(CGPoint)hiddenPoint andAnimateDuration:(NSTimeInterval)times;

@property (nonatomic, strong) UIColor* lineColor;
@property (nonatomic, strong) DynamicBlurView *blurBackground;

@end
