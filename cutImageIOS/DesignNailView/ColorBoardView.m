//
//  ColorBoardView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "ColorBoardView.h"
#import "ColorPickerView.h"
#import "CloverScreen.h"

@interface ColorBoardView()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *configButton;
@property (nonatomic, strong) ColorPickerView *colorPickerView;
@property (nonatomic, strong) UIColor *colorBuffer;

@end

@implementation ColorBoardView

-(id)initWithRect:(CGRect)viewRect andHiddenPoint:(CGPoint)hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.lineColor = [UIColor whiteColor];
        
        self.colorPickerView = [[ColorPickerView alloc]initWithFrame:self.bounds];
        [self addSubview:self.colorPickerView];
        [self layoutCloseButton:self.closeButton];
        [self layoutConfigButton:self.configButton];
    }
    return self;
}

- (void) layoutCloseButton:(UIButton *)button {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeWindowButtonImg = [UIImage imageNamed:@"取消"];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = CGPointMake( [CloverScreen getHorizontal:30] + (closeWindowButtonImg.size.width/2.0) , CGRectGetMaxY(self.bounds) - [CloverScreen getVertical:30] - (closeWindowButtonImg.size.height/2.0) );
    [button setImage:closeWindowButtonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void) layoutConfigButton:(UIButton *)button {
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImg = [UIImage imageNamed:@"确定"];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = CGPointMake(  CGRectGetMaxX(self.bounds) - [CloverScreen getHorizontal:30] - (buttonImg.size.width/2.0) , CGRectGetMaxY(self.bounds) - [CloverScreen getVertical:30] - (buttonImg.size.height/2.0) );
    [button setImage:buttonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(configButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)closeButtonFoo:(id)sender {
    
    [self showViewAtParentView];
}

- (void)configButtonFoo:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"com.clover.cutImageColorIS" object:self.colorPickerView.currentColor];
    self.lineColor = self.colorPickerView.currentColor;
    [self.colorPickerView updateLastColor];
    [self showViewAtParentView];
}

- (void) closeAnimateFinished
{
    [super closeAnimateFinished];
}

- (void)showViewAtParentView {
    [super showViewAtParentView];
    [self.blurBackground showViewAtParentView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
