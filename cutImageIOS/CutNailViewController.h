//
//  ViewController.h
//  cutImageIOS
//
//  Created by vk on 15/8/21.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Bridge2OpenCV.h"
//#import "CutNailViewController.h"

@interface CutNailViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint  returnPoint;
@property (nonatomic, strong) UIImage *editImage;
@property (nonatomic, strong) UIViewController *creatNailRootVC;
@property (nonatomic, assign) CGRect receiveImgRect;

@end

