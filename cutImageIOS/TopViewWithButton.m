//
//  TopViewWithButton.m
//  cutImageIOS
//
//  Created by vk on 15/10/19.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "TopViewWithButton.h"
#import "CloverScreen.h"
@implementation TopViewWithButton
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        float smallButtonWidth = 50;
        UIButton *redoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //NSLog(@"midx = %f",CGRectGetMidX(mainScreen));
        UIImage *redoImg = [UIImage imageNamed:@"上一步"];
        redoButton.frame = CGRectMake( [CloverScreen getHorizontal:270.0] , [CloverScreen getVertical:26.0], redoImg.size.width, redoImg.size.height );
        NSLog(@" %@", NSStringFromCGRect(redoButton.frame));
        
        //self.redoButton.center = CGPointMake(mainScreen.size.width/5,self.addCalculatePoint.center.y + 60);
        //redoButton.backgroundColor = [UIColor whiteColor];
        //[redoButton.layer setCornerRadius:5];
        //[redoButton  setTitle:@"返回" forState:UIControlStateNormal];
        [redoButton setImage:redoImg forState:UIControlStateNormal];
        //[redoButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[redoButton  setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [redoButton  addTarget:self action:@selector(redoButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
        /**
         *  增加前进按钮
         */
        UIImage *undoImg = [UIImage imageNamed:@"下一步"];
        UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        undoButton.frame = CGRectMake(CGRectGetMaxX(redoButton.frame) + [CloverScreen getHorizontal:118]  , CGRectGetMinY(redoButton.frame), undoImg.size.width , undoImg.size.height);
        [undoButton setImage:undoImg forState:UIControlStateNormal];
        //self.undoButton.center = CGPointMake(mainScreen.size.width/5*4,self.moveImg.center.y + 60);
        undoButton.backgroundColor = [UIColor clearColor];
        
        //[undoButton.layer setCornerRadius:5];
        //[undoButton setTitle:@"前进" forState:UIControlStateNormal];
        //[undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[undoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
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
