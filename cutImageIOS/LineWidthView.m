//
//  LineWidthView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "LineWidthView.h"

@interface LineWidthView()

@end

@implementation LineWidthView

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    //if(self = [super init]){
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.lineWidth = 10.0;
    }
    return self;
}

/*
-(void) hiddenViewAtParentView:(UIView *)parentView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
        self.center = self.hiddenViewPoint;
    }
                     completion:^( BOOL finished ){
                         [self removeFromSuperview];
                     }];
}
*/




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
