//
//  RotateCutImageViewController.m
//  cutImageIOS
//
//  Created by vk on 15/9/9.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "RotateCutImageViewController.h"

@interface RotateCutImageViewController ()

@property (nonatomic, strong) UIButton *backStep;
@property (nonatomic, strong) UIImageView *showImgView;
@property (nonatomic, assign) CGRect showImgViewRect;

@end

@implementation RotateCutImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

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
    
    self.showImgView = [[UIImageView alloc]init];
    self.showImgView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.backStep];
    [self.view addSubview:self.showImgView];
    //[self setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backStepFoo:(id)sender
{
 //   [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
