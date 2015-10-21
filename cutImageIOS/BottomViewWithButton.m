//
//  BottomViewWithButton.m
//  cutImageIOS
//
//  Created by vk on 15/10/19.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "BottomViewWithButton.h"


@implementation BottomViewWithButton 

- (id)initWithFrame:(CGRect)frame{
    if( self = [super initWithFrame:frame] ){
        
        float smallButtonWidth = 50.0;
        //返回上一个View按键
        UIButton *popViewCtrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        popViewCtrlButton.frame = CGRectMake( 0, CGRectGetMaxY(self.bounds) - 50, 50, 50);
        popViewCtrlButton.backgroundColor = [UIColor clearColor];
        [popViewCtrlButton.layer setCornerRadius:5];
        [popViewCtrlButton setTitle:@"<-- " forState:UIControlStateNormal];
        [popViewCtrlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popViewCtrlButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [popViewCtrlButton addTarget:self action:@selector(gobackFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加单独添加Mask按键
        UIButton *addMaskPoint = [UIButton buttonWithType:UIButtonTypeCustom];
        addMaskPoint.frame = CGRectMake(  CGRectGetMidX(self.bounds) - 25, 10, smallButtonWidth, 50);
        addMaskPoint.backgroundColor = [UIColor whiteColor];
        [addMaskPoint.layer setCornerRadius:5];
        [addMaskPoint setTitle:@"画笔" forState:UIControlStateNormal];
        [addMaskPoint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addMaskPoint setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [addMaskPoint addTarget:self action:@selector(addMaskPointFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加计算点按键
        UIButton *addCalculatePoint = [UIButton buttonWithType:UIButtonTypeCustom];
        addCalculatePoint.frame = CGRectMake( CGRectGetMinX(addMaskPoint.frame) - (60 + 50) , CGRectGetMinY(addMaskPoint.frame) , smallButtonWidth, 50);
        addCalculatePoint.backgroundColor = [UIColor yellowColor];
        [addCalculatePoint.layer setCornerRadius:5];
        [addCalculatePoint setTitle:@"魔棒" forState:UIControlStateNormal];
        [addCalculatePoint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addCalculatePoint setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [addCalculatePoint addTarget:self action:@selector(cutImageCutFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加删除Mark的按键
        UIButton *deleteMaskPoint = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteMaskPoint.frame = CGRectMake(CGRectGetMaxX(addMaskPoint.frame) + 60, CGRectGetMinY(addMaskPoint.frame), smallButtonWidth, 50);
        deleteMaskPoint.backgroundColor = [UIColor whiteColor];
        [deleteMaskPoint.layer setCornerRadius:5];
        [deleteMaskPoint setTitle:@"删除" forState:UIControlStateNormal];
        [deleteMaskPoint setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteMaskPoint setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [deleteMaskPoint addTarget:self action:@selector(deleteMaskPointFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
        nextStep.frame = CGRectMake( CGRectGetMaxX(self.bounds) - 100, CGRectGetMaxY(self.bounds) - 50, 100, 50);
        nextStep.backgroundColor = [UIColor whiteColor];
        [nextStep.layer setCornerRadius:5];
        [nextStep setTitle:@"下一步 >" forState:UIControlStateNormal];
        [nextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [nextStep addTarget:self action:@selector(nextStepFoo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:popViewCtrlButton];
        [self addSubview:addCalculatePoint];
        [self addSubview:addMaskPoint];
        [self addSubview:deleteMaskPoint];
        [self addSubview:nextStep];
    }
    return self;
}

- (void)gobackFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(goBackTouch)]){
        [self.delegate goBackTouch];
    }
}

- (void)addMaskPointFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(addMaskPointTouch)]){
        [self.delegate addMaskPointTouch];
    }
}

- (void)cutImageCutFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cutImageCutTouch)]){
        [self.delegate cutImageCutTouch];
    }
}

- (void)deleteMaskPointFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteMaskPointTouch)]){
        [self.delegate deleteMaskPointTouch];
    }
}

- (void)nextStepFoo:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(nextStepTouch)]){
        [self.delegate nextStepTouch];
    }
}

@end