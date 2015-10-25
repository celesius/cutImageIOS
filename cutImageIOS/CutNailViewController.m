//
//  ViewController.m
//  cutImageIOS
//
//  Created by vk on 15/8/21.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//  方形编辑区域

#import "CutNailViewController.h"
#import <Foundation/Foundation.h>
#import "UIImage+IF.h"
#import "RotateCutImageViewController.h"
#import "CustomPopAnimation.h"
#import "TopViewWithButton.h"
#import "BottomViewWithButton.h"
//#import "ImageShowView.h"
#import "ImageEditView.h"
#define LINESTEP 5
#define DEFLINEWIDTH 10

@interface CutNailViewController () <TopViewWithButtonDelegate, BottomViewWithButtonDelegate>

@property (nonatomic, strong) ImageEditView  *appImageView;
//@property (nonatomic, strong) UIImageView *showImgView;
@property (nonatomic, strong) UIButton *openPhotoAlbum;
@property (nonatomic, strong) UIButton *addCalculatePoint;
@property (nonatomic, strong) UIButton *addMaskPoint;
@property (nonatomic, strong) UIButton *deleteMaskPoint;
@property (nonatomic, strong) UIButton *moveImg;
@property (nonatomic, strong) UIButton *subtractLineWidth;
@property (nonatomic, strong) UIButton *nextStep;


@property (nonatomic, strong) NSMutableArray *pointArray;  //同时发送的只能有一组array, 删除，添加，选取都是这一个array
@property (nonatomic, strong) UIButton *sysTestButton;
@property (nonatomic, strong) UIButton *resetDrawButton;
@property (nonatomic) CGRect orgRect;
//@property (nonatomic, strong) Bridge2OpenCV *b2opcv;
@property (nonatomic) CGSize imgWindowSize;
@property (nonatomic) CGAffineTransform orgTrf;
@property (nonatomic) BOOL isDraw; //YES是直接画mark NO是添加生长点
@property (nonatomic) BOOL isDelete; //YES则调用删除点，NO是再判断上面的Draw

@property (nonatomic) int setLineWidth;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (nonatomic, strong)  RotateCutImageViewController *rotateCutImageViewController;

@property (nonatomic, strong) dispatch_queue_t getFinnalImageQueue;

@property (nonatomic, strong) CustomPopAnimation *custompopanimation;
@property (nonatomic, assign) BOOL lockNextStep;
@property (nonatomic, assign) CGRect topViewWillAppearAt;
@property (nonatomic, assign) CGRect bottomViewWillAppearAt;
@property (nonatomic, assign) CGPoint imgViewWillAppearAtCenter;
@property (nonatomic, assign) CGSize imgViewWillAppearSize;
@property (nonatomic, assign) CGAffineTransform imgViewOrgTransform;
@property (nonatomic, assign) CGRect imgViewWillAppearAt;

@property (nonatomic, strong) TopViewWithButton *upKeepOutView;
@property (nonatomic, strong) BottomViewWithButton *bottomKeepOutView;


@end

@implementation CutNailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lockNextStep = YES;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    NSLog(@"mainScreen = %@ ", NSStringFromCGRect(mainScreen));
    
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.translucent = YES;
    self.custompopanimation = [[CustomPopAnimation alloc]init];
    self.rotateCutImageViewController = [[RotateCutImageViewController alloc]init];
    self.setLineWidth = DEFLINEWIDTH;              //线宽默认是10
    self.pointArray = [[NSMutableArray alloc]init];

    /**
     *  上工具条
     */
    self.upKeepOutView = [[TopViewWithButton alloc]initWithFrame:CGRectMake(0, -70, CGRectGetWidth(mainScreen), 70)];
    self.upKeepOutView.backgroundColor = [UIColor greenColor];
    self.upKeepOutView.delegate = self;
    self.topViewWillAppearAt = CGRectMake( 0, 0, CGRectGetWidth(self.upKeepOutView.frame), CGRectGetHeight(self.upKeepOutView.frame) );
   
    float appImageViewW = CGRectGetWidth(mainScreen)*(19.0/20.0);
    float appImageViewH = appImageViewW*4.0/3.0;
    self.appImageView = [[ImageEditView alloc]initWithFrame:self.receiveImgRect  andEditImage:self.editImage];
    self.imgViewOrgTransform = self.appImageView.transform;

    //self.appImageView.center = CGPointMake( CGRectGetMidX(mainScreen), self.appImageView.center.y );
    self.imgViewWillAppearAt = CGRectMake( ( CGRectGetWidth(mainScreen) - appImageViewW )/2, CGRectGetHeight(self.upKeepOutView.frame) , appImageViewW, appImageViewH);
    
    self.imgViewWillAppearAtCenter = CGPointMake(CGRectGetMidX(mainScreen), CGRectGetMaxY(self.topViewWillAppearAt) + (appImageViewH/2) );
    
    /**
     *  初始化手势
     */
    [self creatPan];
    /**
     *  下面的工具条
     */
    self.bottomKeepOutView = [[BottomViewWithButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mainScreen), mainScreen.size.width, mainScreen.size.height - (CGRectGetHeight(self.upKeepOutView.frame) + appImageViewH ))];
    self.bottomKeepOutView.backgroundColor = [UIColor redColor];
    self.bottomKeepOutView.delegate = self;
    self.bottomViewWillAppearAt = CGRectMake( 0, CGRectGetHeight(self.upKeepOutView.frame) + appImageViewH, CGRectGetWidth(self.bottomKeepOutView.frame), CGRectGetHeight(self.bottomKeepOutView.frame) );
    /**
     *  打开相册
     */
    self.openPhotoAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openPhotoAlbum.frame = CGRectMake(mainScreen.size.width - 100, mainScreen.size.height - 30, 100, 50);
    self.openPhotoAlbum.backgroundColor = [UIColor whiteColor];
    [self.openPhotoAlbum.layer setCornerRadius:5];
    [self.openPhotoAlbum setTitle:@"打开相册" forState:UIControlStateNormal];
    [self.openPhotoAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.openPhotoAlbum setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.openPhotoAlbum addTarget:self action:@selector(takePictureClick:) forControlEvents:UIControlEventTouchUpInside];
    /**
     *  回复图片位置
     */
    self.sysTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sysTestButton.frame =CGRectMake(0, mainScreen.size.height - 30, 100, 50);
    self.sysTestButton.backgroundColor = [UIColor whiteColor];
    [self.sysTestButton.layer setCornerRadius:5];
    [self.sysTestButton setTitle:@"重置位置" forState:UIControlStateNormal];
    [self.sysTestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sysTestButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.sysTestButton addTarget:self action:@selector(resetPosion:) forControlEvents:UIControlEventTouchUpInside];
    /**
     *  重画按键，点击后消除所有当前图像所有Mask
     */
    /*
    self.resetDrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetDrawButton.frame = CGRectMake(110, mainScreen.size.height - 30, 100, 50);
    self.resetDrawButton.backgroundColor = [UIColor whiteColor];
    [self.resetDrawButton.layer setCornerRadius:5];
    [self.resetDrawButton setTitle:@"重置绘制" forState:UIControlStateNormal];
    [self.resetDrawButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.resetDrawButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.resetDrawButton addTarget:self action:@selector(resetDraw:) forControlEvents:UIControlEventTouchUpInside];
     */

    /**
     *  添加移动图片按键
     */
    //
    /*
    self.moveImg= [UIButton buttonWithType:UIButtonTypeCustom];
    self.moveImg.frame = CGRectMake(mainScreen.size.width - smallButtonWidth, (screenCenter.y - ((mainScreen.size.height - mainScreen.size.width)/4) - (mainScreen.size.width/2) ) + mainScreen.size.width, smallButtonWidth , 50);
    self.moveImg.center = CGPointMake(mainScreen.size.width/5*4,self.moveImg.center.y);
    self.moveImg.backgroundColor = [UIColor whiteColor];
    [self.moveImg.layer setCornerRadius:5];
    [self.moveImg setTitle:@"移动" forState:UIControlStateNormal];
    [self.moveImg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moveImg setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.moveImg addTarget:self action:@selector(enableMoveImg:) forControlEvents:UIControlEventTouchUpInside];
     */
    //
    //[self.view addSubview:self.showImgView];
    [self.view addSubview:self.appImageView];
    [self.view addSubview:self.upKeepOutView];
    [self.view addSubview:self.bottomKeepOutView];
    //[self.view addSubview:self.openPhotoAlbum];
    //[self.view addSubview:self.sysTestButton];
    //[self.view addSubview:self.addCalculatePoint];
    //[self.view addSubview:self.addMaskPoint];
    //[self.view addSubview:self.deleteMaskPoint];
    //[self.view addSubview:self.moveImg];
    //[self.view addSubview:self.resetDrawButton];
    //[self.view addSubview:self.nextStep];
    //[self.view addSubview:self.popViewCtrlButton];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.isDraw = NO;       //默认是添加
    self.isDelete  = NO;
    
    /**
     *  得到最终的剪切图的线程建立
     *
     *  @param "com.clover.cutImageIOS"
     *  @param NULL
     *
     *  @return
     */
    self.getFinnalImageQueue = dispatch_queue_create("com.clover.cutImageIOS", NULL);
    /**
     *  初始化观察者,这个观察者与相关的函数调用要搬移到BottomViewWithButton中
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(haveMaskMatFoo:)
                                                 name:@"com.clover.cutImageGetResultImage"
                                               object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 *  进入此ViewController的动画
 *
 *  @param animated
 */
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"- (void)viewWillAppear:(BOOL)animated");
    [super viewWillAppear:animated];
    //self.appImageView.frame = self.receiveImgRect;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.upKeepOutView.frame = self.topViewWillAppearAt;
                         self.bottomKeepOutView.frame = self.bottomViewWillAppearAt;
                         self.appImageView.frame = self.imgViewWillAppearAt;
                         [self.appImageView resizeAllView];
                     }
                     completion:^(BOOL finished){
                         self.orgRect = self.appImageView.frame;
                     }];
}

/**
 *  标志算法是否有
 *
 *  @param notification 带一个Bool返回值
 */
- (void)haveMaskMatFoo:(NSNotification *)notification{
    NSValue *haveMaskMat = [notification object];
    BOOL hb;
    [haveMaskMat getValue:&hb];
    if(hb){
        [self unLockNextStepButton];
    }
    else{
        [self LockNextStepButton];
    }
}
    
- (void)unLockNextStepButton{
    if(self.lockNextStep){
        self.lockNextStep = !self.lockNextStep;
        //[self.nextStep setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)LockNextStepButton{
    if(!self.lockNextStep){
        self.lockNextStep = !self.lockNextStep;
        //[self.nextStep setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

/**
 *  是否隐藏系统的状态栏
 *
 *  @return YES隐藏NO显示
 */
- (BOOL)prefersStatusBarHidden{
    return YES;
}
/**
 *  自定义VCpush pop动画
 *
 *  @param navigationController 当前app的nc
 *  @param operation            标志push还是pop，用于选择push还是pop动画
 *  @param fromVC               从fromVCpush或pop出
 *  @param toVC                 push或pop到 toVC
 *
 *  @return                     返回自定义的动画
 */
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                animationControllerForOperation :(UINavigationControllerOperation) operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *) toVC
{
    /**
     *  typedef NS_ENUM(NSInteger, UINavigationControllerOperation) {
     *     UINavigationControllerOperationNone,
     *     UINavigationControllerOperationPush,
     *     UINavigationControllerOperationPop,
     *  };
     */
    //push的时候用我们自己定义的customPush
    if ( operation == UINavigationControllerOperationPop ) {
        return self.custompopanimation;//customPush ;
    } else {
        return nil ;
    }
}

- (void)goBackTouch {
    /*
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
     */
    [self.custompopanimation setEndPoint:self.returnPoint];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  将试图恢复到初始位置,并且添加动画
 *
 *  @param sender 按键sender
 */
-(void) resetPosion:(id)sender
{
    //     self.appImageView.transform=CGAffineTransformIdentity;//取消一切形变
    //self.appImageView.transform =CGAffineTransformScale(self.orgTrf, 1, 1);
    [UIView animateWithDuration:.5 animations:^{
        self.appImageView.transform = CGAffineTransformMake(1, 0.0, 0.0, 1, 0, 0);
        self.appImageView.frame = self.orgRect;
    }];
}
/**
 *  重置所有绘制
 *  这个操作现在不需要了
 *  @param sender
 */
/*
-(void) resetDraw:(id)sender
{
    self.appImageView.transform =CGAffineTransformScale(self.orgTrf, 1, 1);
    self.appImageView.frame = self.orgRect;
    self.setLineWidth = DEFLINEWIDTH;
    [self.appImageView resetAllMask];
}
*/
/**
 *  回退操作
 */
- (void) redoButtonTouch
{
    [self.appImageView redo];
}

/**
 *  前进操作
 */
-(void) undoButtonTouch
{
    [self.appImageView undo];
}

-(void) cutImageCutTouch
{
    [self.appImageView setMove:NO];
    [self.appImageView setUserInteractionEnabled:YES];
    self.appImageView.isDraw = NO;
    self.appImageView.isDelete = NO;
    self.addCalculatePoint.backgroundColor  = [UIColor yellowColor];
    self.addMaskPoint.backgroundColor  = [UIColor whiteColor];
    self.deleteMaskPoint.backgroundColor  = [UIColor whiteColor];
    self.moveImg.backgroundColor  = [UIColor whiteColor];
    self.isDraw = NO;
    self.isDelete= NO;
    //[self.appImageView removeGestureRecognizer:self.panGestureRecognizer];
    //[self.appImageView removeGestureRecognizer:self.pinchGestureRecognizer];
}

-(void) addMaskPointTouch           //直接添加种子点
{
    [self.appImageView setMove:NO];
    [self.appImageView setUserInteractionEnabled:YES];
    self.appImageView.isDraw = YES;
    self.appImageView.isDelete = NO;
    self.addCalculatePoint.backgroundColor  = [UIColor whiteColor];
    self.addMaskPoint.backgroundColor       = [UIColor yellowColor];
    self.deleteMaskPoint.backgroundColor    = [UIColor whiteColor];
    self.moveImg.backgroundColor            = [UIColor whiteColor];
    self.isDraw = YES;
    self.isDelete= NO;
    //[self.appImageView removeGestureRecognizer:self.panGestureRecognizer];
    //[self.appImageView removeGestureRecognizer:self.pinchGestureRecognizer];
}

-(void) deleteMaskPointTouch
{
    [self.appImageView setMove:NO];
    [self.appImageView setUserInteractionEnabled:YES];
    self.appImageView.isDraw = NO;
    self.appImageView.isDelete = YES;
    self.addCalculatePoint.backgroundColor  = [UIColor whiteColor];
    self.addMaskPoint.backgroundColor       = [UIColor whiteColor];
    self.deleteMaskPoint.backgroundColor    = [UIColor yellowColor];
    self.moveImg.backgroundColor            = [UIColor whiteColor];
    self.isDelete = YES;
    //[self.appImageView removeGestureRecognizer:self.panGestureRecognizer];
    //[self.appImageView removeGestureRecognizer:self.pinchGestureRecognizer];
}

-(void) enableMoveImg:(id)sender
{
    [self.appImageView setMove:YES];
    [self.appImageView setUserInteractionEnabled:YES];
    self.addCalculatePoint.backgroundColor  = [UIColor whiteColor];
    self.addMaskPoint.backgroundColor       = [UIColor whiteColor];
    self.deleteMaskPoint.backgroundColor    = [UIColor whiteColor];
    self.moveImg.backgroundColor            = [UIColor yellowColor];
   
    //[self.appImageView addGestureRecognizer:self.panGestureRecognizer];
    //[self.appImageView addGestureRecognizer:self.pinchGestureRecognizer];
}

-(void) nextStepTouch
{
    if(!self.lockNextStep){
        dispatch_async(self.getFinnalImageQueue, ^{
            UIImage *setImage = [self.appImageView getReusltImage];
            [self.rotateCutImageViewController setImageRect:self.orgRect andImage:setImage];
            [self.rotateCutImageViewController setCreatNailRootVC:self.creatNailRootVC];
        });
        [self toRotateCutImageVCAnimationWithTimeDuration:0.5];
        [self.navigationController pushViewController:self.rotateCutImageViewController animated:YES];
    }
}
/**
 *  利用系统现有的动画定义VCpush动画
 *
 *  @param duration <#duration description#>
 */
- (void) toRotateCutImageVCAnimationWithTimeDuration:(float)duration{
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

/**
 *  开打相册功能函数
 *
 *  @param sender
 */
-(void)takePictureClick:(id)sender
{
    
    /*注：使用，需要实现以下协议：UIImagePickerControllerDelegate,
     UINavigationControllerDelegate
     */
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //设置图片源(相簿)
    //picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置代理
    picker.delegate = self;
    //设置可以编辑
    picker.allowsEditing = YES;
    //打开拾取器界面
    [self presentViewController:picker animated:YES completion:nil];
}
/**
 *  完成照片选择
 *
 *  @param picker 传递的picker
 *  @param info   取得的媒体内容描述字典
 */
-(void)imagePickerController:(UIImagePickerController *)picker  didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //加载图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    CGRect corpRect = [[info objectForKey:@"UIImagePickerControllerCropRect"]CGRectValue];
    [self.appImageView  setPicture:image];
    //重置绘制线宽
    self.setLineWidth = DEFLINEWIDTH;
    //每次打开时，将appImageView归到初始位置
    //self.appImageView.frame = self.orgRect;
    //[self creatPan];
    //选择框消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  取消照片选择
 *
 *  @param picker 传递的picker
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  初始化手势动作相关接口
 *  添加多点触摸支持
 */
-(void) creatPan
{
    //self.appImageView.multipleTouchEnabled = YES;
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.panGestureRecognizer.delegate = self;
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePinch:)];
    self.pinchGestureRecognizer.delegate = self;
    [self.appImageView addGestureRecognizer:self.panGestureRecognizer];
    [self.appImageView addGestureRecognizer:self.pinchGestureRecognizer];
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    
    if (recognizer.state==UIGestureRecognizerStateChanged) {
        //NSLog(@" UIGestureRecognizerStateChanged ");
        CGPoint translation = [recognizer translationInView:self.view];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        CGAffineTransform show =  recognizer.view.transform;
        CGAffineTransform show2 =  self.orgTrf;
    }
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    if (recognizer.state==UIGestureRecognizerStateChanged) {
        recognizer.view.transform=CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1; //不重置为1则变化会太快
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded){
        if(recognizer.view.transform.a > 2.0){
            [UIView animateWithDuration:.25 animations:^{
                recognizer.view.transform= CGAffineTransformMake(2.0, 0.0, 0.0, 2.0, 0, 0) ;//取消一切形变
            }];
        }
        else if( recognizer.view.transform.a < 0.6 ){
            [UIView animateWithDuration:.25 animations:^{
                recognizer.view.transform= CGAffineTransformMake(0.6, 0.0, 0.0, 0.6, 0, 0) ;//取消一切形变
            }];
        }
        
        [self.appImageView setLineScale:recognizer.view.transform.a];
        NSLog(@"view.transform.a = %f",recognizer.view.transform.a);
        CGAffineTransform show =  recognizer.view.transform;
        CGAffineTransform show2 =  self.orgTrf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addPoint2Array:(CGPoint)aPoint
{
    if( aPoint.x >= 0 && aPoint.x < self.orgRect.size.width && aPoint.y >= 0 && aPoint.y < self.orgRect.size.height ){
    [self.pointArray addObject: [NSValue valueWithCGPoint:aPoint]];
    }
}


- (void)topViewAppearAnimationWithView:(UIView *)tView {

}

- (void)bottomViewAppearAnimationWithView:(UIView *)bView {

}

/*
-(void) setReturnPoint:(CGPoint)setPoint
{
    self.rurnPoint = setPoint;
}
 */

/**
 *  画图测试
 */



@end
