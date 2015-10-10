//
//  DrawViewModel.h
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawViewModel : NSObject

//+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width  StartPoint:(CGPoint)startPoint  EndPoint:(CGPoint) endPoint IsDot:(BOOL)isDot;
+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width;

@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIBezierPath *path;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;
@property (assign, nonatomic) BOOL isDot;
@property (assign, nonatomic) BOOL isLineWith2Dot;

@end

