//
//  ImageEditView.m
//  cutImageIOS
//
//  Created by vk on 15/9/1.
//  Copyright (c) 2015年 Clover. All rights reserved.
//

#import "ImageEditView.h"
#import "UIImage+IF.h"

@interface ImageEditView()
/**
 *  画图用View
 */
@property(nonatomic, strong) DrawView *drawView;
/**
 *  显示图片用View
 */
@property (nonatomic, strong)  UIImageView *pictureImage;
/**
 *  显示计算结果Image
 */
@property (nonatomic, strong) UIImageView *maskImage;
/**
 *  算法模块
 */
@property (nonatomic, strong) Bridge2OpenCV *b2opcv;
/**
 线程queue
 */
@property (nonatomic, strong) dispatch_queue_t imageProcessQueue;

@property (nonatomic, strong) UIImage *inputImageBuffer;

@end

@implementation ImageEditView

-(id)initWithFrame:(CGRect)frame andEditImage:(UIImage *)editImage;
{
    if(self = [super initWithFrame:frame])
    {
        self.drawView = [[DrawView alloc]initWithFrame:self.bounds andIsCutImage:YES];
        self.pictureImage = [[UIImageView alloc]initWithFrame:self.bounds];
        self.maskImage = [[UIImageView alloc]initWithFrame:self.bounds];
        
        self.pictureImage.backgroundColor = [UIColor blackColor];
        self.drawView.backgroundColor = [UIColor clearColor];
        self.maskImage.backgroundColor = [UIColor clearColor]; //[UIColor colorWithWhite:0.5 alpha:0.5];
       // self.maskImage.alpha = 0.5;
        
        self.b2opcv = [[Bridge2OpenCV alloc]init];
        self.b2opcv.delegate = self;
        self.drawView.delegate = self;
        
        //UIImage *imageInit =  [UIImage imageWithColor:self.pictureImage.backgroundColor andRect:CGRectMake(0, 0, self.pictureImage.frame.size.width, self.pictureImage.frame.size.width)];
        //[self.b2opcv setCalculateImage:editImage andWindowSize:self.frame.size];
        [self setPicture:editImage];
        self.inputImageBuffer = editImage;
        
        self.isMove = NO;
        self.isDraw = NO;       //默认是添加
        self.isDelete  = NO;
        
        self.imageProcessQueue = dispatch_queue_create("com.clover.cutImageIOS", NULL);
    
        self.backgroundColor = [UIColor greenColor];
        
        [self addSubview:self.pictureImage];
        [self addSubview:self.drawView];
        [self addSubview:self.maskImage];
    }
    return self;
}

-(void)setPicture:(UIImage *)setImage
{
    //NSLog(@"view sW = %f",self.frame.size.width);
    //NSLog(@"view sH = %f",self.frame.size.height);
    [self.b2opcv setCalculateImage:setImage andWindowSize:self.frame.size];
    [self.drawView setPhotoImage:setImage];
    self.pictureImage.image = setImage;
}

-(void) setMove:(BOOL) isMove
{
    [self.drawView setMove:isMove];
}

-(void) redo
{
    [self.b2opcv redoPoint];
//    [self.drawView redo];
}

-(void) undo
{
    [self.b2opcv undoPoint];
//    [self.drawView undo];
}

-(void) setLineScale:(float) scale
{
    //[self.drawView setLineScale:scale];
    self.drawView.lineScale = 1/scale;
}

-(void) resetAllMask
{
    [self.b2opcv resetAllMask];
//    [self.drawView resetDraw];
}

-(void) resultImageReady:(UIImage *)sendImage andHaveMaskMat:(bool)have
{
    NSValue *sendV = [NSValue value:&have withObjCType:@encode(BOOL) ];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor *sendColor = [UIColor colorWithRed:197.0/255.0 green:81.0/255.0 blue:223.0/255.0 alpha:100.0/255.0];
//        self.pictureImage.image = sendImage;
//        self.maskImage.image = [self.b2opcv imageBlackToSetColor:sendImage];
//        self.maskImage.image = [self.b2opcv imageWhiteToSetColor:sendImage setColor:[UIColor colorWithRed:197.0/255.0 green:81.0/255.0 blue:223.0/255.0 alpha:100.0/255.0]];
        self.maskImage.image = [self.b2opcv imageWhiteToSetColor:sendImage setColor:sendColor];//[UIColor redColor]];
       [[NSNotificationCenter defaultCenter]postNotificationName:@"com.clover.cutImageGetResultImage" object:sendV];
    });
}

-(UIImage *)getReusltImage
{
    UIImage * resultImg = [self.b2opcv getCutResult];
    return resultImg;
}


-(void) setPointArray:(NSMutableArray *) pointArray andLineWide:(float) linaWidth;
{
    //q6yddispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
    dispatch_async(self.imageProcessQueue, ^{
        if(self.isDelete){
            [self.b2opcv setDeletePoint:pointArray andLineWidth:linaWidth*2];
        }
        else{
            if (self.isDraw) {
                [self.b2opcv setDrawPoint:pointArray andLineWidth:linaWidth*2];
            }
            else{
                [self.b2opcv setCreatPoint:pointArray andLineWidth:linaWidth*2];
            }
        }
    });
}


- (void) resizeAllView
{
    self.drawView.frame = self.bounds;
    self.pictureImage.frame = self.bounds;
    self.maskImage.frame = self.bounds;
    [self.b2opcv updateWindowSize:self.bounds.size];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
