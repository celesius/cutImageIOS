//
//  DynamicView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "DynamicView.h"

@interface DynamicView()

@property (nonatomic, assign) CGRect showViewRect;
@property (nonatomic, assign) CGPoint showViewPoint;
@property (nonatomic, assign) CGPoint hiddenViewPoint;
@property (nonatomic, assign) CGAffineTransform orgTrf;
@property (nonatomic, assign) NSTimeInterval animDuration;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL animationLock;

@end

@implementation DynamicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    if(self = [super init]){
        self.hiddenViewPoint = hiddenPoint;
        self.frame = viewRect;
        self.showViewRect = viewRect;
        self.orgTrf = self.transform;
        self.animDuration = times;
        self.animationLock = NO;
        self.isShow = NO;
        self.hidden = YES;
        self.alpha = 0.01;
        self.showViewPoint = CGPointMake(  self.showViewRect.origin.x + (self.showViewRect.size.width/2)  , self.showViewRect.origin.y + (self.showViewRect.size.height/2));
        [self.layer setCornerRadius:5];
    }
    return self;
}

-(void) showViewAtParentView{
    if(!self.animationLock)
    {
        self.animationLock = YES;
        if(!self.isShow){
            self.hidden = NO;
            self.center = self.hiddenViewPoint;
            self.transform = CGAffineTransformMake(0.1, 0, 0, 0.1, 0, 0);
            //[parentView addSubview:self];
            [UIView animateWithDuration:self.animDuration animations:^{
                // self.frame = self.showViewRect;
                self.alpha = 1.0;
                self.transform = self.orgTrf;
                self.center = self.showViewPoint; //CGPointMake(50, 50);
            }
                             completion:^( BOOL finished ){
                                 self.animationLock = NO;
                                 self.isShow = YES;
                             }];
        }
        else{
            [UIView animateWithDuration:self.animDuration animations:^{
                self.transform = CGAffineTransformMake(0.1, 0, 0, 0.1, 0, 0);
                self.center = self.hiddenViewPoint;
                self.alpha = 0.01;
            }
                             completion:^( BOOL finished ){
                               //  [self removeFromSuperview];
                                 self.animationLock = NO;
                                 self.isShow = NO;
                                 self.hidden = YES;
                             }];
        }
    }
}

@end
