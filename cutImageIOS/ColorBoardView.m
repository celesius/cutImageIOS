//
//  ColorBoardView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "ColorBoardView.h"
#import "ColorPickerView.h"

@interface ColorBoardView()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) ColorPickerView *colorPickerView;

@end

@implementation ColorBoardView

-(id)initWithRect:(CGRect)viewRect andHiddenPoint:(CGPoint)hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.lineColor = [UIColor whiteColor];
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float closeButtonW = 30.0;
        float closeButtonH = closeButtonW;
        self.closeButton.frame = CGRectMake(0, 0, closeButtonW, closeButtonH);
        [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[self.closeButton setTintColor:[UIColor blackColor]];
        [self.closeButton addTarget:self action:@selector(closeButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        self.colorPickerView = [[ColorPickerView alloc]initWithFrame:self.bounds];
        
        [self addSubview:self.colorPickerView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)closeButtonFoo:(id)sender{
    [self closeView];
}

- (void) closeAnimateFinished
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"com.clover.cutImageColorIS" object:self.colorPickerView.currentColor];
    self.lineColor = self.colorPickerView.currentColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
