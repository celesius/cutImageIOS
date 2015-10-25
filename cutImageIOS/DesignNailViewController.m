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
#import "LineWidthShowView.h"
#import "ColorBoardView.h"
#import "TopViewWithButton.h"
#import "CloverScreen.h"
#import "DynamicBlurView.h"

#define TEXTSIZE 26

@interface DesignNailViewController () <TopViewWithButtonDelegate>

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

@property (nonatomic, strong) UILabel *deleteLineLabel;
@property (nonatomic, strong) UILabel *lineColorLabel;
@property (nonatomic, strong) UILabel *lineWidthLabel;


//@property (nonatomic, strong) UIButton *redo;
//@property (nonatomic, strong) UIButton *undo;

@property (nonatomic, strong) UIView *actionViewL1;
@property (nonatomic, strong) UIView *actionViewL2;
@property (nonatomic, strong) UIColor *beforDetelet;

/**
 *  sub view
 */
@property (nonatomic, strong) LineWidthView *lwView;
@property (nonatomic, strong) ColorBoardView *cbView;
@property (nonatomic, strong) LineWidthShowView *lwsView;
@property (nonatomic, strong) DynamicBlurView *fxblurViewMask;
@property (nonatomic, strong) DynamicBlurView *lwViewBlurBG;

@end

@implementation DesignNailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.customPopAnimation = [[CustomPopAnimation alloc]init];
    self.navigationController.delegate = self;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    NSLog(@" DesignNailViewController mainScreen = %@", NSStringFromCGRect(mainScreen));
   
    TopViewWithButton *tvwb = [[TopViewWithButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreen), 44)];
    tvwb.backgroundColor = [UIColor blackColor];
    tvwb.delegate = self;
    
    
    self.drawNailView = [[DrawView alloc]initWithFrame:CGRectMake( (CGRectGetWidth(mainScreen) - [CloverScreen getHorizontal:696])/2.0  , CGRectGetMaxY(tvwb.frame), [CloverScreen getHorizontal:696 ], [CloverScreen getVertical:928] ) andIsCutImage:NO];
    //self.drawNailView.center = CGPointMake( screenCenter.x, screenCenter.y - ((mainScreen.size.height - mainScreen.size.width)/4) );
    self.drawNailView.backgroundColor = [UIColor clearColor];
    
    self.drawBackboard = [[UIView alloc]initWithFrame:self.drawNailView.frame];
    self.drawBackboard.backgroundColor = [self stringTOColor:@"292829"];
    
    /**
     *  deleteLine用于对其下面的所有按键。
     *            |
     *            |
     *            |
     *Width---->Color<----擦除
     */
    [self greatSetLineColorImgButtonWithRefRect:self.drawNailView.frame];
    [self greatSetLineWidthButtonWithRefRect:self.lineColorLabel.frame];       //lift
    [self greatDeleteLineButtonWithRefRect:self.lineColorLabel.frame];            //right
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame: CGRectMake( 0, CGRectGetMaxY(self.deleteLineLabel.frame) + [CloverScreen getVertical:54], CGRectGetWidth(mainScreen), 1)];
    bottomLine.backgroundColor =  [self stringTOColor:@"3a3a3a"];
    [self.view addSubview:bottomLine];
    
    [self createPopViewButtonWithRefRect:bottomLine.frame];
   
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [self createFinishButton:finishButton andRefRect:bottomLine.frame];
    
    //[self greatUndoButton:mainScreen];
    //[self greatRedoButton:mainScreen];
    
//    CGRect lwViewRect = CGRectMake( (mainScreen.size.width/2) - 150 , self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height - 75, 300, 50);
    CGRect lwViewRect = CGRectMake( CGRectGetMinX(mainScreen), CGRectGetMaxY(mainScreen) - [CloverScreen getVertical:269], CGRectGetWidth(mainScreen), [CloverScreen getVertical:269]);
    self.lwView = [[LineWidthView alloc]initWithRect:lwViewRect andHiddenPoint:self.setLineWidth.center andAnimateDuration:0.5 andTouchButton:self.setLineWidth];
//    self.lwView.backgroundColor = [self stringTOColor:@"252525"];
    self.lwView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:0.5];  //[self stringTOColor:@"252525"];
  
    self.lwViewBlurBG = [[DynamicBlurView alloc] initWithRect:lwViewRect andHiddenPoint:self.setLineWidth.center andAnimateDuration:0.5];
    [self setupBlurView:self.lwViewBlurBG];
    [self.lwView setBlurBGView:self.lwViewBlurBG];
    
    
    UIImage *lwsBackImg = [UIImage imageNamed:@"线宽显示"];
    
    float lwsViewW = lwsBackImg.size.width;
    float lwsViewH = lwsBackImg.size.height;
    CGRect lwsViewRect = CGRectMake( CGRectGetMidX(self.drawNailView.frame) - (lwsViewW/2), CGRectGetMidY(self.drawNailView.frame) - (lwsViewH/2), lwsViewW, lwsViewH);
    self.lwsView = [[LineWidthShowView alloc]initWithRect:lwsViewRect andHiddenPoint:self.setLineWidth.center andAnimateDuration:0.5];
    self.lwsView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.5];
    [self.lwView setShowView:self.lwsView];
    
    self.fxblurViewMask = [[DynamicBlurView alloc]initWithRect:lwsViewRect andHiddenPoint:self.setLineWidth.center andAnimateDuration:0.5];
    [self setupBlurView:self.fxblurViewMask];
    [self.lwView setBlurView:self.fxblurViewMask];
   
    float cbViewW = mainScreen.size.width*9/10;
    float cbViewH = mainScreen.size.height*8/9;
//    CGRect cbViewRect = CGRectMake( (mainScreen.size.width/2) - (cbViewW/2), self.drawNailView.center.y - (cbViewH/2), cbViewW, cbViewH);
    CGRect cbViewRect = CGRectMake( CGRectGetMinX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - [CloverScreen getVertical:820], CGRectGetWidth(self.view.bounds), [CloverScreen getVertical:820]);
    self.cbView = [[ColorBoardView alloc]initWithRect:cbViewRect andHiddenPoint:self.setLineColor.center andAnimateDuration:0.5];
    self.cbView.backgroundColor = [self stringTOColor:@"252525"]; //[UIColor colorWithRed:255.0/255.0 green:255.0/248.0 blue:255.0/220.0 alpha:1.0];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:tvwb];
    
    [self.view addSubview:self.drawBackboard];
    [self.view addSubview:self.drawNailView];
    [self.view addSubview:self.popViewCtrlButton];
    [self.view addSubview:self.setLineWidth];
    [self.view addSubview:self.setLineColor];
    [self.view addSubview:self.deleteLine];
    //[self.view addSubview:self.redo];
    //[self.view addSubview:self.undo];
    [self.view addSubview:self.lwViewBlurBG];
    [self.view addSubview:self.lwView];
    [self.view addSubview:self.cbView];
    [self.view addSubview:self.fxblurViewMask];
    [self.view addSubview:self.lwsView];
    
    [self buttonAction:self.deleteLine andInitAction:NO andView:self.view];
    /**
     *  注册观察者
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawViewLineWidth:)
                                                 name:@"cutImageSetLineWidth"
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void) setupBlurView:(DynamicBlurView *)view {
   view.blurRadius = 10;
   view.tintColor = [UIColor clearColor];
   view.underlyingView = self.view;
}

-(void)drawViewLineWidth:(NSNotification *)notification{
    NSValue *outV = [notification object];
    float lineW;
    [outV getValue:&lineW];
    NSLog(@"%f",lineW);
    self.drawNailView.lineWidth = lineW;
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
    [self.lwsView showViewAtParentView];
    [self.fxblurViewMask showViewAtParentView];
    [self.lwViewBlurBG showViewAtParentView];
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

- (void) undoButtonTouch {
    [self.drawNailView undo];
}

- (void) redoButtonTouch {
    [self.drawNailView redo];
}
/*
-(void) undoFoo:(id)sender{
    [self.drawNailView undo];
}

-(void) redoFoo:(id)sender{
    [self.drawNailView redo];
}
*/
 
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
        //self.beforDetelet = self.cbView.lineColor;
        self.drawNailView.lineColor = [UIColor blackColor];
    }
    else{
        self.actionViewL1.hidden = YES;
        self.actionViewL2.hidden = YES;
        self.drawNailView.lineColor = self.cbView.lineColor;
    }
}

- (void) greatSetLineWidthButtonWithRefRect:(CGRect) refRect {
    UIImage *setLinwWidthImg = [UIImage imageNamed:@"线条"];
    self.lineWidthLabel = [[UILabel alloc]init];
    self.lineWidthLabel.frame = CGRectMake(0, 0, ( ((float)TEXTSIZE/2)+1)*2, ((float)TEXTSIZE/2)+1 );
    self.lineWidthLabel.center = CGPointMake( CGRectGetMinX(refRect) - [CloverScreen getHorizontal:120] - (CGRectGetWidth(self.lineWidthLabel.frame)/2) , CGRectGetMidY(refRect));
    //self.lineWidthLabel.center = CGPointMake( CGRectGetMidX(mr), [CloverScreen getVertical:50] + deleteLineButtonImg.size.height + CGRectGetHeight(self.deleteLineLabel.frame) + CGRectGetMaxY(refRect) );
    self.lineWidthLabel.font =  [UIFont fontWithName:@"Helvetica" size:(float)TEXTSIZE/2];
    [self.lineWidthLabel setTextColor:[UIColor whiteColor]];
    [self.lineWidthLabel setTextAlignment:NSTextAlignmentCenter];
    [self.lineWidthLabel setText:@"线条"];
    [self.view addSubview:self.lineWidthLabel];
    
    self.setLineWidth = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.setLineWidth.frame = CGRectMake( 0, 0, setLinwWidthImg.size.width, setLinwWidthImg.size.height);
    self.setLineWidth.frame = CGRectMake( 0, CGRectGetMaxY(self.drawNailView.frame) + [CloverScreen getVertical:54] - ((50 - setLinwWidthImg.size.height)/2), 50, 50);
    self.setLineWidth.center = CGPointMake( CGRectGetMidX(self.lineWidthLabel.frame), self.setLineWidth.center.y );
    
    [self.setLineWidth setImage:setLinwWidthImg forState:UIControlStateNormal];
    [self.setLineWidth addTarget:self action:@selector(setLineWidthFoo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) greatDeleteLineButtonWithRefRect:(CGRect) refRect {
    UIImage *deleteLineButtonImg = [UIImage imageNamed:@"橡皮"];
    
    self.deleteLineLabel = [[UILabel alloc]init];
    self.deleteLineLabel.frame = CGRectMake(CGRectGetMaxX(refRect) + [CloverScreen getHorizontal:120], CGRectGetMinY(refRect), ( ((float)TEXTSIZE/2) +1) * 2, ((float)TEXTSIZE/2)+1);
   
    [self.deleteLineLabel setFont:[UIFont fontWithName:@"Helvetica" size:(float)(TEXTSIZE/2)]];
    [self.deleteLineLabel setTextColor:[UIColor whiteColor]];
    [self.deleteLineLabel setTextAlignment:NSTextAlignmentCenter];
    [self.deleteLineLabel setText:@"擦除"];
    [self.view addSubview:self.deleteLineLabel];

    
    self.deleteLine = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteLine.frame = CGRectMake(0, CGRectGetMaxY(self.drawNailView.frame) + [CloverScreen getVertical:54] - ((50 - deleteLineButtonImg.size.height)/2), 50, 50);
    self.deleteLine.center = CGPointMake(CGRectGetMidX(self.deleteLineLabel.frame), self.deleteLine.center.y);
    [self.deleteLine setImage:deleteLineButtonImg forState:UIControlStateNormal];
    [self.deleteLine addTarget:self action:@selector(deleteLineFoo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) greatSetLineColorImgButtonWithRefRect:(CGRect) refRect {
    UIImage *setLineColorImg = [UIImage imageNamed:@"调色板"];
    CGRect mr = [UIScreen mainScreen].bounds;

    self.setLineColor = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setLineColor.frame = CGRectMake( 0, CGRectGetMaxY(refRect) + [CloverScreen getVertical:54] - ((50 - setLineColorImg.size.height)/2) , 50, 50 );
//    self.setLineColor.center = CGPointMake( CGRectGetMidX(self.lineColorLabel.frame), CGRectGetMinY(self.lineColorLabel.frame) - [CloverScreen getVertical:20] - (setLineColorImg.size.height/2) );
    self.setLineColor.center = CGPointMake( CGRectGetMidX(refRect), self.setLineColor.center.y);
    [self.setLineColor setImage:setLineColorImg forState:UIControlStateNormal];
    [self.setLineColor addTarget:self action:@selector(setLineColorFoo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineColorLabel = [[UILabel alloc]init];
    self.lineColorLabel.frame = CGRectMake(0, CGRectGetMaxY(self.setLineColor.frame) - ((50 - setLineColorImg.size.height)/2) + [CloverScreen getVertical:36.0], ( ((float)TEXTSIZE/2)+1)*3, ((float)TEXTSIZE/2)+1 );
    self.lineColorLabel.center = CGPointMake( CGRectGetMidX(refRect), self.lineColorLabel.center.y);
    self.lineColorLabel.font =  [UIFont fontWithName:@"Helvetica" size:13];
    [self.lineColorLabel setTextColor:[UIColor whiteColor]];
    [self.lineColorLabel setTextAlignment:NSTextAlignmentCenter];
    [self.lineColorLabel setText:@"调色板"];
    [self.view addSubview:self.lineColorLabel];
}

/**
 *  返回页面
 *
 *  @param refRect 
 */

- (void) createPopViewButtonWithRefRect:(CGRect) refRect {
    CGRect ms = [UIScreen mainScreen].bounds;
    float bH = CGRectGetHeight(ms) - CGRectGetMaxY(refRect);
    float bW = bH;
    CGRect setButton = CGRectMake( 0, CGRectGetMaxY(refRect), bW, bH);
    self.popViewCtrlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.popViewCtrlButton.frame = setButton;//CGRectMake( 0, CGRectGetHeight(mainScreen)  - 50 + CGRectGetMinY(mainScreen) , 50, 50);
    self.popViewCtrlButton.backgroundColor = [UIColor clearColor];
    //[self.popViewCtrlButton.layer setCornerRadius:5];
    [self.popViewCtrlButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.popViewCtrlButton addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createFinishButton:(UIButton *)button andRefRect:(CGRect) refRect {
    CGRect ms = [UIScreen mainScreen].bounds;
    float bH = CGRectGetHeight(ms) - CGRectGetMaxY(refRect);
    float bW = bH;
    CGRect setButton = CGRectMake( CGRectGetMaxX(ms) - bW - [CloverScreen getHorizontal:30] , CGRectGetMaxY(refRect), bW, bH);
    button.frame = setButton;
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (UIColor *) stringTOColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}


/*
-(void) greatRedoButton:(CGRect)mainS{
    self.redo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redo.frame = CGRectMake(0, 0, 50, 50);
    self.redo.center = CGPointMake(mainS.size.width/3, (self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height) + (self.setLineWidth.frame.size.height/2) + 50);
    self.redo.backgroundColor = [UIColor whiteColor];
    [self.redo.layer setCornerRadius:25];
    [self.redo setTitle:@"<<" forState:UIControlStateNormal];
    [self.redo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.redo setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.redo  addTarget:self action:@selector(redoFoo:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) greatUndoButton:(CGRect)mainS{
    self.undo = [UIButton buttonWithType:UIButtonTypeCustom];
    self.undo.frame = CGRectMake(0, 0, 50, 50);
    self.undo.center = CGPointMake(mainS.size.width*2/3, (self.drawNailView.frame.origin.y + self.drawNailView.frame.size.height) + (self.setLineWidth.frame.size.height/2) + 50);
    self.undo.backgroundColor = [UIColor whiteColor];
    [self.undo.layer setCornerRadius:25];
    [self.undo setTitle:@">>" forState:UIControlStateNormal];
    [self.undo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.undo setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.undo   addTarget:self action:@selector(undoFoo:) forControlEvents:UIControlEventTouchUpInside];
}
*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
