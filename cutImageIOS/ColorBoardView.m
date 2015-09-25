//
//  ColorBoardView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "ColorBoardView.h"

@interface ColorBoardView()

@end

@implementation ColorBoardView

-(id)initWithRect:(CGRect)viewRect andHiddenPoint:(CGPoint)hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.lineColor = [UIColor whiteColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
