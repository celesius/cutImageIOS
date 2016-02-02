//
//  CustomPushAnimation.m
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "CustomPushAnimation.h"
@interface CustomPushAnimation()

@property (nonatomic, assign) CGPoint animationStartPoint;
@property (nonatomic, assign) CGRect mainScreenRect;
@property (nonatomic, assign) float toViewOffset;

@end

@implementation CustomPushAnimation

-(id)initWithIsFromViewHiddenStatusBar:(BOOL)isHave{
    if(self = [super init]){
        self.animationStartPoint = CGPointMake(0, 0);
        self.mainScreenRect = [[UIScreen mainScreen]applicationFrame];
        if(isHave)
            self.toViewOffset = 0;
        else
            self.toViewOffset = 10;
        
    }
    return self;
}

- ( NSTimeInterval ) transitionDuration : ( id < UIViewControllerContextTransitioning > ) transitionContext
{
    return 0.5 ;
}

- ( void ) animateTransition : ( id < UIViewControllerContextTransitioning > ) transitionContext
{
    //目的ViewController
    UIViewController * toViewController = [ transitionContext viewControllerForKey : UITransitionContextToViewControllerKey ] ;
    //起始ViewController
    UIViewController * fromViewController = [ transitionContext viewControllerForKey : UITransitionContextFromViewControllerKey ] ;
    //添加toView到上下文
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    //自定义动画
    toViewController.view.transform = CGAffineTransformMake(0.1, 0, 0, 0.1, 0, 0); //CGAffineTransformMakeTranslation(320 , 568 ) ;
    toViewController.view.center = self.animationStartPoint;
    [ UIView animateWithDuration : [ self transitionDuration : transitionContext ] animations : ^ {
        //fromViewController.view.transform = CGAffineTransformMakeTranslation ( - 320 , - 568 ) ;
        [fromViewController.view setAlpha:0];
        toViewController.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 1);  //CGAffineTransformIdentity ;
        toViewController.view.center = CGPointMake(self.mainScreenRect.size.width/2, (self.mainScreenRect.size.height/2 + self.toViewOffset)) ;
    } completion : ^ ( BOOL finished ) {
        [fromViewController.view setAlpha:1];
        [toViewController setNeedsStatusBarAppearanceUpdate];
        //fromViewController . view . transform = CGAffineTransformIdentity ;
        // 声明过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]] ;
        //fromViewController.navigationController.delegate = nil;
    } ] ;
}

-(void) setStartPoint:(CGPoint)point
{
    self.animationStartPoint = point;
}

@end
