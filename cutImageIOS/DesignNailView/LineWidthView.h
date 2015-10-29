//
//  LineWidthView.h
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicView.h"
#import "LineWidthShowView.h"
#import "DynamicBlurView.h"

@interface LineWidthView : DynamicView 

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times andTouchButton:(UIButton *)button;

//- (void) closeShowView:(LineWidthShowView *)showView

@property (nonatomic, assign) float lineWidth;
@property (nonatomic, strong) LineWidthShowView *showView;
@property (nonatomic, strong) DynamicBlurView *blurView;
@property (nonatomic, strong) DynamicBlurView *blurBGView;

@end
