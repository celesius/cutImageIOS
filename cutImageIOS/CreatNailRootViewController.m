//
//  CreatNailRootViewController.m
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 Clover. All rights reserved.
//

#import "CreatNailRootViewController.h"
//#import "ViewController.h"
#import "DesignNailViewController.h"
#import "CustomPushAnimation.h"
#import "TWPhotoPickerController.h"

@interface CreatNailRootViewController ()

@property(nonatomic, strong) UIButton *cutNailButton;
@property(nonatomic, strong) UIButton *drawNailButton;
@property(nonatomic, strong) CustomPushAnimation *customPushAnimation;

@end

@implementation CreatNailRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    CGRect mainScreen = [[UIScreen mainScreen]applicationFrame];
    
    self.cutNailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cutNailButton.frame = CGRectMake(0, 0, mainScreen.size.width/4, mainScreen.size.width/4);
    self.cutNailButton.center = CGPointMake(mainScreen.size.width/4, mainScreen.size.height/4);
    self.cutNailButton.backgroundColor = [UIColor whiteColor];
    [self.cutNailButton.layer setCornerRadius:5.0];
    [self.cutNailButton setTitle:@"剪切甲型" forState:UIControlStateNormal];
    [self.cutNailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cutNailButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [self.cutNailButton addTarget:self action:@selector(cutNailButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.cutNailButton addTarget:self action:@selector(openPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
   
    self.drawNailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.drawNailButton.frame = CGRectMake(0, 0, mainScreen.size.width/4, mainScreen.size.width/4);
    self.drawNailButton.center = CGPointMake(mainScreen.size.width*3/4, mainScreen.size.height/4);
    self.drawNailButton.backgroundColor = [UIColor whiteColor];
    [self.drawNailButton.layer setCornerRadius:5.0];
    [self.drawNailButton setTitle:@"绘制甲型" forState:UIControlStateNormal];
    [self.drawNailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.drawNailButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.drawNailButton addTarget:self action:@selector(drawNailButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
   
    self.customPushAnimation = [[CustomPushAnimation alloc]initWithIsFromViewHiddenStatusBar:[self prefersStatusBarHidden]];
    [self.view addSubview:self.cutNailButton];
    [self.view addSubview:self.drawNailButton];
    
    self.rotateVCBackPoint = CGPointMake(CGRectGetMidX(mainScreen), CGRectGetMidY(mainScreen));
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation :(UINavigationControllerOperation) operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *) toVC
{
    /**
     *  typedef NS_ENUM(NSInteger, UINavigationControllerOperation) {
     *     UINavigationControllerOperationNone,
     *     UINavigationControllerOperationPush,
     *     UINavigationControllerOperationPop,
     *  };
     */
    //push的时候用我们自己定义的customPush
    if ( operation == UINavigationControllerOperationPush ) {
        return self.customPushAnimation;//customPush ;
    } else {
        return nil ;
    }
}

#if 0
-(void)cutNailButtonFoo:(id)sender{
    ViewController *cutNailViewC = [[ViewController alloc]init];
    [cutNailViewC setReturnPoint:self.cutNailButton.center];
   /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = YES;
    */
    //[self.navigationController.view an]
    //if(self.navigationController.delegate == nil){
        self.navigationController.delegate = self;
    //}
   
    [self.customPushAnimation setStartPoint:.]
    
    [self.navigationController pushViewController:cutNailViewC animated:YES];
}
#endif

- (void)openPhotoAlbum:(id)sender{
    TWPhotoPickerController *twppc = [[ TWPhotoPickerController alloc ]init];
    self.navigationController.delegate = self;
    [twppc setReturnPoint:self.cutNailButton.center];
    [twppc setCreatNailRootVC:self];
    twppc.cropBlock = ^(UIImage *image) {
        NSLog(@"Image");
    };
    [self.customPushAnimation setStartPoint:self.cutNailButton.center];
    [self.navigationController pushViewController:twppc animated:YES];
    //[self presentViewController:twppc animated:YES completion:nil];
    
}

-(void)drawNailButtonFoo:(id)sender{
    DesignNailViewController *vc = [[DesignNailViewController alloc]init];
    [vc setReturnPoint:self.drawNailButton.center];
    /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = YES;
     */
    //if(self.navigationController.delegate == nil){
    self.navigationController.delegate = self;
    //}
    [self.customPushAnimation setStartPoint:self.drawNailButton.frame.origin];
    [self.navigationController pushViewController:vc animated:YES];


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
