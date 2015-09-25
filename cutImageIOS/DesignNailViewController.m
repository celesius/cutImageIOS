//
//  DesignNailViewController.m
//  cutImageIOS
//
//  Created by vk on 15/9/23.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "DesignNailViewController.h"
#import "DrawView.h"
#import "CustomPopAnimation.h"
#import "LineWidthView.h"
#import "ColorBoardView.h"

@interface DesignNailViewController ()

@property (nonatomic, strong) DrawView *drawNailView;
@property (nonatomic, strong) UIView *drawBackboard;
@property (nonatomic, strong) UIButton *popViewCtrlButton;
@property (nonatomic, strong) CustomPopAnimation *customPopAnimation;
/**
 *  Draw Button
 */
@property (nonatomic, strong) UIButton *setLineWidth;
@property (nonatomic, strong) UIButton *setLineColor;
@property (nonatomic, strong) UIButton *deleteLine;
@property (nonatomic, strong) UIButton *redo;
@property (nonatomic, strong) UIButton *undo;

@property (nonatomic, strong) UIView *actionViewL1;
@property (nonatomic, strong) UIView *actionViewL2;

/**
 *  sub view
 */
@property (nonatomic, strong) LineWidthView *lwView;
@property (nonatomic, strong) ColorBoardView *cbView;

@end

@implementation DesignNailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customPopAnimation = [[CustomPopAnimation alloc]init];
    self.navigationController.delegate = self;
    CGRect mainScreen = [[UIScreen mainScreen]applicationFrame];
    CGPoint screenCenter = CGPointMake(mainScreen.size.width/2, mainScreen.size.height/2 + 20);
    self.drawNailView = [[DrawView alloc]initWithFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y, mainScreen.size.width, mainScreen.size.width) andIsCutImage:NO];
    self.drawNailView.center = CGPointMake( screenCenter.x, screenCenter.y - ((mainScreen.size.height - mainScreen.size.width)/4) );
    self.drawNailView.backgroundColor = [UIColor clearColor];
    
    self.drawBackboard = [[UIView alloc]initWithFrame:self.drawNailView.frame];
    self.drawBackboard.backgroundColor = [UIColor blackColor];
   
    self.popViewCtrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.popViewCtrlButton.frame = CGRectMake( 0, self.drawNailView.frame.origin.y - 50, 50, 50);
    self.popViewCtrlButton.backgroundColor = [UIColor clearColor];
    [self.popViewCtrlButton.layer setCornerRadius:5];
    [self.popViewCtrlButton setTitle:@"X" forState:UIControlStateNormal];
    [self.popViewCtrlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.popViewCtrlButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.popViewCtrlButton addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
  
    self.setLineWidth = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setLineWidth.frame = CGRectMake(0, 0, 50, 50);
    self.setLineWidth.center = CGPointMake((mainScreen.size.width/3)/2, (self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height) + (self.setLineWidth.frame.size.height/2) );
    self.setLineWidth.backgroundColor = [UIColor whiteColor];
    [self.setLineWidth.layer setCornerRadius:25];
    [self.setLineWidth setTitle:@"宽" forState:UIControlStateNormal];
    [self.setLineWidth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.setLineWidth setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.setLineWidth addTarget:self action:@selector(setLineWidthFoo:) forControlEvents:UIControlEventTouchUpInside];
   
    self.setLineColor = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setLineColor.frame = CGRectMake(0, 0, 50, 50);
    self.setLineColor.center = CGPointMake(mainScreen.size.width/2, (self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height) + (self.setLineWidth.frame.size.height/2));
    self.setLineColor.backgroundColor = [UIColor whiteColor];
    [self.setLineColor.layer setCornerRadius:25];
    [self.setLineColor setTitle:@"色" forState:UIControlStateNormal];
    [self.setLineColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.setLineColor setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.setLineColor addTarget:self action:@selector(setLineColorFoo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self greatDeleteLineButton:mainScreen];
    
    
    
    CGRect lwViewRect = CGRectMake( (mainScreen.size.width/2) - 100 , self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height - 75, 200, 50);
    self.lwView = [[LineWidthView alloc]initWithRect:lwViewRect andHiddenPoint:self.setLineWidth.center andAnimateDuration:0.5];
    self.lwView.backgroundColor = [UIColor greenColor];
   
    float cbViewW = mainScreen.size.width*2/3;
    float cbViewH = cbViewW*3/4;
    CGRect cbViewRect = CGRectMake( (mainScreen.size.width/2) - (cbViewW/2), self.drawNailView.center.y - (cbViewH/2), cbViewW, cbViewH);
    self.cbView = [[ColorBoardView alloc]initWithRect:cbViewRect andHiddenPoint:self.setLineColor.center andAnimateDuration:0.5];
    self.cbView.backgroundColor = [UIColor redColor];
    
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.drawBackboard];
    [self.view addSubview:self.drawNailView];
    [self.view addSubview:self.popViewCtrlButton];
    [self.view addSubview:self.setLineWidth];
    [self.view addSubview:self.setLineColor];
    [self.view addSubview:self.deleteLine];
    [self.view addSubview:self.lwView];
    [self.view addSubview:self.cbView];
    
    [self buttonAction:self.deleteLine andInitAction:NO andView:self.view];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                animationControllerForOperation :(UINavigationControllerOperation) operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *) toVC
{
    //push的时候用我们自己定义的customPush
    if ( operation == UINavigationControllerOperationPop ) {
        return self.customPopAnimation;//customPush ;
    } else {
        return nil ;
    }
}

-(void) goback:(id)sender{
    /*
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    */
    [self.customPopAnimation setEndPoint:self.returnPoint];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setLineWidthFoo:(id)sender{
//    [self.lwView showViewAtParentView:self.view ];
    [self.lwView showViewAtParentView];
}

-(void)setLineColorFoo:(id)sender{
    [self.cbView showViewAtParentView];
}

-(void) deleteLineFoo:(id)sender{
    static BOOL act = NO;
    [self buttonActionSet:act];
    //[self buttonAction:self.deleteLine andInitAction:act andView:self.view];
    act = !act;
}

-(void) buttonAction:(UIButton *)aButton andInitAction:(BOOL)action andView:(UIView *)currentView{
    //BOOL thisButtonAction = NO;
    float aButtonW = aButton.frame.size.width;
    float aButtonH = aButton.frame.size.height;
    
    self.actionViewL1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aButtonW+2, aButtonH+2)];
    self.actionViewL1.center = aButton.center;
    [self.actionViewL1.layer setCornerRadius: self.actionViewL1.frame.size.width/2]; //aButton.layer.cornerRadius];
    self.actionViewL1.backgroundColor = [UIColor blackColor];
    self.actionViewL1.hidden = YES;
    
    self.actionViewL2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aButtonW+5, aButtonH+5)];
    self.actionViewL2.center = aButton.center;
    [self.actionViewL2.layer setCornerRadius: self.actionViewL2.frame.size.width/2];//self.actionViewL2.frame.size.width]; //aButton.layer.cornerRadius];
    self.actionViewL2.backgroundColor = [UIColor yellowColor];
    self.actionViewL2.hidden = YES;
    
    [currentView insertSubview:self.actionViewL1 belowSubview:aButton];
    [currentView insertSubview:self.actionViewL2 belowSubview:self.actionViewL1];
    /*
    if(action){
        self.actionViewL1.hidden = NO;
        self.actionViewL2.hidden = NO;
    }
    else{
        self.actionViewL1.hidden = YES;
        self.actionViewL2.hidden = YES;
    }
    */
}

-(void) buttonActionSet:(BOOL) action {
    if(action){
        self.actionViewL1.hidden = NO;
        self.actionViewL2.hidden = NO;
    }
    else{
        self.actionViewL1.hidden = YES;
        self.actionViewL2.hidden = YES;
    }
    
}

-(void) greatDeleteLineButton:(CGRect)mainS{
    self.deleteLine = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteLine.frame = CGRectMake(0, 0, 50, 50);
    self.deleteLine.center = CGPointMake((mainS.size.width/3)*2 + (mainS.size.width/3/2), (self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height) + (self.setLineWidth.frame.size.height/2));
    self.deleteLine.backgroundColor = [UIColor whiteColor];
    [self.deleteLine.layer setCornerRadius:25];
    [self.deleteLine setTitle:@"删" forState:UIControlStateNormal];
    [self.deleteLine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.deleteLine setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.deleteLine addTarget:self action:@selector(deleteLineFoo:) forControlEvents:UIControlEventTouchUpInside];
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