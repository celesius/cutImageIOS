//
//  TWPhotoPickerController.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWPhotoPickerController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, copy) void(^cropBlock)(UIImage *image);
@property (nonatomic, assign) CGPoint returnPoint;
@property (nonatomic, strong) UIViewController *creatNailRootVC;
@property (nonatomic, assign) float hiddenViewTime;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
