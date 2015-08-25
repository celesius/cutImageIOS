//
//  bridge2OpenCV.m
//  cutImageIOS
//
//  Created by vk on 15/8/24.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "bridge2OpenCV.h"
#import <opencv2/opencv.hpp> 
#import "CutoutImagePacking.h"

@interface bridge2OpenCV ()

@property (nonatomic) CutoutImagePacking *cutoutImagePacking;
@property (nonatomic,strong) UIImage *srcImg;

@end

@implementation bridge2OpenCV

-(id)initWithImage:(UIImage *)setImage
{
    if(self = [super init])
    {
        self.srcImg = setImage;
        self.cutoutImagePacking = new CutoutImagePacking;//[[CutoutImage alloc]init];
    }
    return self;

}

@end
