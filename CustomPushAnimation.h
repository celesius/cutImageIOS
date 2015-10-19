//
//  CustomPushAnimation.h
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>
-(id)initWithIsFromViewHiddenStatusBar:(BOOL)isHave;
-(void) setStartPoint:(CGPoint) point;
@end
