//
//  RotateCutImageViewController.h
//  cutImageIOS
//
//  Created by vk on 15/9/9.
//  Copyright (c) 2015年 Clover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatNailRootViewController.h"

@interface RotateCutImageViewController : UIViewController <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

-(void) setImageRect:(CGRect) setRect andImage:(UIImage *)setImage;
@property (nonatomic, strong) CreatNailRootViewController *creatNailRootVC;

@end
