//
//  bridge2OpenCV.m
//  cutImageIOS
//
//  Created by vk on 15/8/24.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "Bridge2OpenCV.h"
#import <opencv2/opencv.hpp> 
#import "CutoutImagePacking.h"

@interface Bridge2OpenCV ()

@property (nonatomic) CutoutImagePacking *cutoutImagePacking;
@property (nonatomic,strong) UIImage *srcImg;
//@property (nonatomic) CGSize windowSize; //屏幕坐标系大小
@property (nonatomic) float xScale;
@property (nonatomic) float yScale;

@end

@implementation Bridge2OpenCV

-(id)init
{
    if(self = [super init])
    {
        self.cutoutImagePacking = new CutoutImagePacking;//[[CutoutImage alloc]init];
    }
    return self;
}

-(id)initWithImage:(UIImage *)setImage
{
    if(self = [super init])
    {
        self.srcImg = setImage;
        self.cutoutImagePacking = new CutoutImagePacking;//[[CutoutImage alloc]init];
        
        cv::Mat sendImageRGBA = [self CVMat:setImage];
        cv::Mat sendImageBGR;
        cv::cvtColor(sendImageRGBA, sendImageBGR, CV_RGBA2BGR);
        NSLog(@"sendImageBGR.cols = %d",sendImageBGR.cols);
        NSLog(@"sendImageBGR.rows = %d",sendImageBGR.rows);
        self.cutoutImagePacking->setColorImage(sendImageBGR, 20);
    }
    return self;
}

-(void) setCalculateImage:(UIImage *)setImage andWindowSize:(CGSize)winSize
{
    cv::Mat sendImageRGBA = [self CVMat:setImage];
    cv::Mat sendImageBGR;
    cv::cvtColor(sendImageRGBA, sendImageBGR, CV_RGBA2BGR);
    NSLog(@"sendImageBGR.cols = %d",sendImageBGR.cols);
    NSLog(@"sendImageBGR.rows = %d",sendImageBGR.rows);
    self.cutoutImagePacking->setColorImage(sendImageBGR, 20);
    self.xScale = sendImageBGR.cols/winSize.width;
    self.yScale = sendImageBGR.rows/winSize.height;
}

-(void) setDrawPoint:(NSMutableArray*)selectPoint andLineWidth:(int)lineWidth
{
    //存储类型转换，nsmutablearray转换为 std::vector
    std::vector<cv::Point> sendPoint;
    for(int i =0;i<[selectPoint count];i++){
        NSValue *pv = [selectPoint objectAtIndex:i];
        CGPoint p = [pv CGPointValue];
        cv::Point cvp;
        cvp.x = (int)(p.x*self.xScale);
        cvp.y = (int)(p.y*self.yScale);
        sendPoint.push_back(cvp);
    }
    cv::Mat getMat;
    self.cutoutImagePacking->drawMask(sendPoint, lineWidth, getMat);
    cv::cvtColor(getMat, getMat, CV_BGR2RGB);
    UIImage *sendUIImage = [self UIImageFromCVMat:getMat];
    if(self.delegate && [self.delegate respondsToSelector:@selector(resultImageReady:)]){
        [self.delegate resultImageReady:sendUIImage];
    }
}

-(void) setCreatPoint:(NSMutableArray*)selectPoint andLineWidth:(int)lineWidth
{
    std::vector<cv::Point> sendPoint;
    for(int i =0;i<[selectPoint count];i++){
        NSValue *pv = [selectPoint objectAtIndex:i];
        CGPoint p = [pv CGPointValue];
        cv::Point cvp;
        cvp.x = (int)(p.x*self.xScale);
        cvp.y = (int)(p.y*self.yScale);
        sendPoint.push_back(cvp);
    }
    cv::Mat getMat;
    self.cutoutImagePacking->creatMask(sendPoint, lineWidth, getMat);
    cv::cvtColor(getMat, getMat, CV_BGR2RGB);
    UIImage *sendUIImage = [self UIImageFromCVMat:getMat];
    if(self.delegate && [self.delegate respondsToSelector:@selector(resultImageReady:)]){
        [self.delegate resultImageReady:sendUIImage];
    }
    cv::Mat debugMat = self.cutoutImagePacking->getDebugMat();
    cv::Mat debugMat2 = self.cutoutImagePacking->getDebugMat2();
    UIImage *debugImg = [self UIImageFromCVMat:debugMat];
    UIImage *debugImg2 = [self UIImageFromCVMat:debugMat2];
}

-(void) setDeletePoint:(NSMutableArray*)selectPoint andLineWidth:(int)lineWidth
{
    std::vector<cv::Point> sendPoint;
    for(int i =0;i<[selectPoint count];i++){
        NSValue *pv = [selectPoint objectAtIndex:i];
        CGPoint p = [pv CGPointValue];
        cv::Point cvp;
        cvp.x = (int)(p.x*self.xScale);
        cvp.y = (int)(p.y*self.yScale);
        sendPoint.push_back(cvp);
    }
    cv::Mat getMat;
    self.cutoutImagePacking->deleteMask(sendPoint, lineWidth, getMat);
    cv::cvtColor(getMat, getMat, CV_BGR2RGB);
    UIImage *sendUIImage = [self UIImageFromCVMat:getMat];
    if(self.delegate && [self.delegate respondsToSelector:@selector(resultImageReady:)]){
        [self.delegate resultImageReady:sendUIImage];
    }
}
//UIImage转mat，注意。uiimage转换为的cvMat可能是rgba的，所以需要再次修改
-(cv::Mat)CVMat:( UIImage *)uiiameg
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(uiiameg.CGImage);
    CGFloat cols = uiiameg.size.width;
    CGFloat
    rows = uiiameg.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), uiiameg.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
//mat转uiimage,这里注意，
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
