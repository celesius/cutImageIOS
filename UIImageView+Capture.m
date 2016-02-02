//
//  UIImageView+Capture.m
//  cutImageIOS
//
//  Created by vk on 15/10/27.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "UIImageView+Capture.h"

@implementation UIImageView(Capture)

- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
