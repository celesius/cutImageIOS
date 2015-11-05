//
//  RotateCutImageViewController.m
//  cutImageIOS
//
//  Created by vk on 15/9/9.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "RotateCutImageViewController.h"
#import "KTOneFingerRotationGestureRecognizer.h"
#import "CustomPopAnimation.h"

@interface RotateCutImageViewController ()

@property (nonatomic, strong) UIButton *backStep;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIImageView *showImgView;
@property (nonatomic, assign) CGRect showImgViewRect;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property (nonatomic) CGAffineTransform orgShowImgViewTransform;
@property (nonatomic, assign) BOOL popVCbyFinishOperation;
@property (nonatomic, strong) CustomPopAnimation *customPopAnimation;

@end

@implementation RotateCutImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    self.navigationController.delegate = self;
    self.customPopAnimation = [[CustomPopAnimation alloc]init];
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view.layer setCornerRadius:5.0];
    
    CGRect mainScreen = [[UIScreen mainScreen] applicationFrame];
    
    self.backStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backStep.frame = CGRectMake(mainScreen.origin.x, mainScreen.origin.y, 100, 50);
    self.backStep.backgroundColor = [UIColor clearColor];
    [self.backStep.layer setCornerRadius:5];
    [self.backStep setTitle:@"< 上一步" forState:UIControlStateNormal];
    [self.backStep setTitleColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:112.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.backStep setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.backStep addTarget:self action:@selector(backStepFoo:) forControlEvents:UIControlEventTouchUpInside];
  
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishButton.frame = CGRectMake( CGRectGetWidth(mainScreen) - 100 , mainScreen.origin.y, 100, 50);
    self.finishButton.backgroundColor = [UIColor clearColor];
    [self.finishButton.layer setCornerRadius:5];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:112.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.finishButton addTarget:self action:@selector(finishButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.showImgView = [[UIImageView alloc]init];
    self.orgShowImgViewTransform = self.showImgView.transform;
    self.showImgView.backgroundColor = [UIColor clearColor];//[UIColor greenColor];
  //  self.showImgView.backgroundColor = [UIColor clearColor];
   
    //[self creatPan];
    [self.showImgView setUserInteractionEnabled:YES];
    [self addRotationGestureToView:self.showImgView];
    [self addTapGestureToView:self.showImgView numberOfTaps:1];
    
    
    [self.view addSubview:self.backStep];
    [self.view addSubview:self.finishButton];
    [self.view addSubview:self.showImgView];
    
    self.popVCbyFinishOperation = NO;
    //[self setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backStepFoo:(id)sender{
    [self backPopVCAnimationWithTimeDuration:0.5];
    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) backPopVCAnimationWithTimeDuration:(float)duration{
    self.popVCbyFinishOperation = NO;
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

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
    if ( operation == UINavigationControllerOperationPop  && self.popVCbyFinishOperation) {
        return self.customPopAnimation ;//customPush ;
    } else {
        return nil ;
    }
}


- (void)finishButtonFoo:(id)sender{
    self.popVCbyFinishOperation = YES;
    [self.customPopAnimation setEndPoint:self.creatNailRootVC.rotateVCBackPoint];
    //self.navigationController = self.creatNailRootVC.navigationController;
    [self.navigationController popToViewController:self.creatNailRootVC animated:YES];
}

-(void) setImageRect:(CGRect) setRect andImage:(UIImage *)setImage;
{
    self.showImgView.frame = setRect;
    dispatch_async( dispatch_get_main_queue() , ^{
        self.showImgView.image = setImage;
    });
}

-(void) viewWillAppear:(BOOL)animated
{
    self.showImgView.transform = self.orgShowImgViewTransform;
}

-(void) creatPan
{
    self.rotationGestureRecognizer  = [[UIRotationGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleRotation:)];
    self.rotationGestureRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:self.rotationGestureRecognizer];
}

- (void) handleRotation:(UIPanGestureRecognizer*) recognizer
{
    NSLog(@"rotationGestureRecognizer");
}

- (void)addRotationGestureToView:(UIView *)view
{
   KTOneFingerRotationGestureRecognizer *rotation = [[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
   [view addGestureRecognizer:rotation];
//   [rotation release];
}

- (void)addTapGestureToView:(UIView *)view numberOfTaps:(NSInteger)numberOfTaps
{
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
   [tap setNumberOfTapsRequired:numberOfTaps];
   [view addGestureRecognizer:tap];
//   [tap release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void)rotating:(KTOneFingerRotationGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformRotate([view transform], [recognizer rotation])];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer
{
   UIView *view = [recognizer view];
   [view setTransform:CGAffineTransformMakeRotation(0)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
