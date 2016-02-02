//
//  LineWidthShowView.m
//  cutImageIOS
//
//  Created by vk on 15/10/22.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "LineWidthShowView.h"

@interface LineWidthShowView ()

@property (assign, nonatomic) float LineWidth;
@property (strong, nonatomic) UIImage *backImg;

@end

@implementation LineWidthShowView


-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        //self.layer.contents
        self.backImg = [UIImage imageNamed:@"线宽显示"];
        
    }
    
    return self;
}

- (void) showLineWidth:(float) lineWidth {
    self.LineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawCircleWithContext:context onRect:rect];
}

- (void) drawCircleWithContext:(CGContextRef)context onRect:(CGRect)rect {

    //[_lineColor set];
    [[UIColor whiteColor] set];
    //CGContextDrawImage(context, rect, self.backImg.CGImage);
    CGContextSetLineWidth(context, 2.0);
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextAddEllipseInRect(context, [self calculateRect:center andRadius:self.LineWidth/2.0 + 2.0]);//在这个框中画圆
    CGContextStrokePath(context);
}

- (CGRect) calculateRect:(CGPoint)center andRadius:(float) radius {
    float x = center.x - radius;
    float y = center.y - radius;
    return CGRectMake(x, y, 2.0*radius, 2.0*radius);
}

@end
