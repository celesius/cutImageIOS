//
//  maskLayer.m
//  cutImageIOS
//
//  Created by vk on 15/10/26.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "MaskLayer.h"

@implementation MaskLayer


- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/2.0 );
    CGContextSetStrokeColorWithColor(ctx, self.maskColor);
    CGContextStrokeEllipseInRect(ctx,  CGRectInset(self.bounds, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/4.0, (CGRectGetWidth(self.bounds) - CGRectGetWidth(self.transparentRect))/4.0) );  //self.transparentRect);
    
}

@end
