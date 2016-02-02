//
//  CustomPopAnimation.h
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomPopAnimation : NSObject<UIViewControllerAnimatedTransitioning>
-(id) init;
-(void) setEndPoint:(CGPoint) point;
@end
