//
//  bridge2OpenCV.h
//  cutImageIOS
//
//  Created by vk on 15/8/24.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol bridge2OpenCVDelegate  <NSObject>
-(void) resultImageReady:(UIImage *) sendImage;
@end

@interface bridge2OpenCV : NSObject

-(id) initWithImage:(UIImage *)setImage;
-(void) setCalculateImage:(UIImage *)setImage;

@property (nonatomic,weak) id<bridge2OpenCVDelegate> delegate;

@end

