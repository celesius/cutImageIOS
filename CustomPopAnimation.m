//
//  CustomPopAnimation.m
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "CustomPopAnimation.h"
@interface CustomPopAnimation()
@property(nonatomic, assign) CGPoint animationEndPoint;
@property(nonatomic, assign) CGRect mainScreenRect;

@end


@implementation CustomPopAnimation
-(id)init{
    if(self = [super init]){
        self.animationEndPoint = CGPointMake(0, 0);
        self.mainScreenRect = [[UIScreen mainScreen]applicationFrame];
    }
    return self;
}

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>) transitionContext
{
    return 0.5 ;
}
-(void) animateTransition:(id<UIViewControllerContextTransitioning>) transitionContext
{
    //目的ViewController
    UIViewController * toViewController = [ transitionContext viewControllerForKey : UITransitionContextToViewControllerKey ] ;
    //起始ViewController
    UIViewController * fromViewController = [ transitionContext viewControllerForKey : UITransitionContextFromViewControllerKey ] ;
    //添加toView到上下文
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    //自定义动画
    [toViewController.view setAlpha:0];
    fromViewController.view.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);  //CGAffineTransformIdentity ;
    [ UIView animateWithDuration : [self transitionDuration:transitionContext] animations : ^ {
        [toViewController.view setAlpha:1];
        fromViewController.view.center = self.animationEndPoint;
        fromViewController.view.transform = CGAffineTransformMake(0.1, 0, 0, 0.1, 0, 0);  //CGAffineTransformIdentity ;
        [fromViewController.view setAlpha:0.01];
    } completion : ^ ( BOOL finished ) {
        //[fromViewController.view setAlpha:1];
        //fromViewController . view . transform = CGAffineTransformIdentity ;
        // 声明过渡结束时调用 completeTransition: 这个方法
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]] ;
    } ] ;
}

-(void) setEndPoint:(CGPoint)point
{
    self.animationEndPoint = point;
}


@end
