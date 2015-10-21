//
//  TopViewWithButton.m
//  cutImageIOS
//
//  Created by vk on 15/10/19.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "TopViewWithButton.h"

@implementation TopViewWithButton
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        float smallButtonWidth = 50;
        UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //NSLog(@"midx = %f",CGRectGetMidX(mainScreen));
        redoButton.frame = CGRectMake(CGRectGetMidX(self.bounds) - 60, CGRectGetMaxY(self.bounds) - 50 , smallButtonWidth, 50);
        
        //self.redoButton.center = CGPointMake(mainScreen.size.width/5,self.addCalculatePoint.center.y + 60);
        redoButton.backgroundColor = [UIColor whiteColor];
        [redoButton.layer setCornerRadius:5];
        [redoButton  setTitle:@"返回" forState:UIControlStateNormal];
        [redoButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [redoButton  setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [redoButton  addTarget:self action:@selector(redoButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
        /**
         *  增加前进按钮
         */
        
        UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        undoButton.frame = CGRectMake(CGRectGetMidX(self.bounds) + 10  , CGRectGetMaxY(self.bounds) - 50, smallButtonWidth , 50);
        //self.undoButton.center = CGPointMake(mainScreen.size.width/5*4,self.moveImg.center.y + 60);
        undoButton.backgroundColor = [UIColor whiteColor];
        [undoButton.layer setCornerRadius:5];
        [undoButton setTitle:@"前进" forState:UIControlStateNormal];
        [undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [undoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [undoButton addTarget:self action:@selector(undoButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:redoButton];
        [self addSubview:undoButton];
        
    }
    return self;
}

- (void)redoButtonFoo:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(redoButtonTouch)] ){
        [self.delegate redoButtonTouch];
    }
}

- (void)undoButtonFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(undoButtonTouch)] ){
        [self.delegate undoButtonTouch];
    }

}

@end
