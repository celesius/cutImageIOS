//
//  maskLayer.h
//  cutImageIOS
//
//  Created by vk on 15/10/26.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface MaskLayer : CALayer

@property (nonatomic, assign) CGColorRef maskColor;
@property (nonatomic, assign) CGRect transparentRect;

@end
