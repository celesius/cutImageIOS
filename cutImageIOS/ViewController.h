//
//  ViewController.h
//  cutImageIOS
//
//  Created by vk on 15/8/21.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Bridge2OpenCV.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint  returnPoint;

@end

