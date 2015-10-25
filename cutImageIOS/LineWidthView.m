//
//  LineWidthView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "LineWidthView.h"
#import "DotButton.h"
#import "CloverScreen.h"
#define MAXBUTTON 5;
#define ACTIONEDGE 4.0;

@interface LineWidthView()

@property (nonatomic, strong) DotButton *lwButton10;
@property (nonatomic, strong) DotButton *lwButton15;
@property (nonatomic, strong) DotButton *lwButton20;
@property (nonatomic, strong) DotButton *lwButton25;
@property (nonatomic, strong) DotButton *lwButton30;
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, assign) CGRect showRect;
@property (nonatomic, assign) float actionEdge;

@property (nonatomic, assign) float lineWidthBuffer;

@property (nonatomic, strong) UISlider *lineWidthSlider;

@property (nonatomic, strong) UIButton *touchButton;


@end

@implementation LineWidthView

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times andTouchButton:(UIButton *)button{
    //if(self = [super init]){
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.touchButton = button;
        self.showRect = viewRect;
        self.lineWidth = 10.0;
        self.lineWidthBuffer = self.lineWidth;
        //self.lwButton10 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton15 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton20 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton25 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton30 = [DotButton buttonWithType:UIButtonTypeCustom];
        self.actionEdge = ACTIONEDGE;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"大小"]];
        img.frame = CGRectMake( [CloverScreen getHorizontal:64], [CloverScreen getVertical:70], CGRectGetWidth(img.frame), CGRectGetHeight(img.frame) );
        [self addSubview:img];
        
        UIButton *closeWindowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self layoutCloseButton:closeWindowButton];
       
        UIButton *configWindowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self layoutConfigButton:configWindowButton];

        UIImage *sliderRefImg = [UIImage imageNamed:@"滑动条"];
        self.lineWidthSlider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame) + [CloverScreen getHorizontal:15] , 0,  [CloverScreen getHorizontal:sliderRefImg.size.width]*2.0, 50)];
        self.lineWidthSlider.center = CGPointMake(self.lineWidthSlider.center.x, CGRectGetMidY(img.frame));
        
        [self layoutAndSetSlider:self.lineWidthSlider andRefRect:img.frame];
       
       
                
        //float lwButtonW = self.frame.size.width/MAXBUTTON;
        //float lwButtonH = lwButtonW;
        //CGRect lwButtonRect = CGRectMake(0, 0, lwButtonW, lwButtonH);
        
        /*
        CGPoint b1Centre = CGPointMake( lwButtonW/2,self.frame.size.height/2 );
        self.lwButton10 = [[DotButton alloc]initWithFrame:lwButtonRect andCentre:b1Centre andColor:[UIColor blackColor] andDotRadius:5];
        [self.lwButton10.aButton addTarget:self action:@selector(changeLineWidth10:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint b2Centre = CGPointMake( lwButtonW + lwButtonW/2, self.frame.size.height/2);
        self.lwButton15 = [[DotButton alloc]initWithFrame:lwButtonRect andCentre:b2Centre andColor:[UIColor blackColor] andDotRadius:15/2];
        [self.lwButton15.aButton addTarget:self action:@selector(changeLineWidth15:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint b3Centre = CGPointMake( lwButtonW*2 + lwButtonW/2, self.frame.size.height/2);
        self.lwButton20 = [[DotButton alloc]initWithFrame:lwButtonRect andCentre:b3Centre andColor:[UIColor blackColor] andDotRadius:20/2];
        [self.lwButton20.aButton addTarget:self action:@selector(changeLineWidth20:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint b4Centre = CGPointMake( lwButtonW*3 + lwButtonW/2, self.frame.size.height/2);
        self.lwButton25 = [[DotButton alloc]initWithFrame :lwButtonRect andCentre:b4Centre andColor:[UIColor blackColor] andDotRadius:25/2];
        [self.lwButton25.aButton addTarget:self action:@selector(changeLineWidth25:) forControlEvents:UIControlEventTouchUpInside];
        CGPoint b5Centre = CGPointMake( lwButtonW*4 + lwButtonW/2, self.frame.size.height/2);
        self.lwButton30 = [[DotButton alloc]initWithFrame:lwButtonRect andCentre:b5Centre andColor:[UIColor blackColor] andDotRadius:30/2];
        [self.lwButton30.aButton addTarget:self action:@selector(changeLineWidth30:) forControlEvents:UIControlEventTouchUpInside];
         */
       
        /*
        self.actionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.lineWidth+self.actionEdge, self.lineWidth+self.actionEdge)];
        self.actionView.center = self.lwButton10.center;
        [self.actionView.layer setCornerRadius:self.actionView.frame.size.width/2];
        self.actionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.0 blue:0 alpha:0.9];
         */
        
        //[self addSubview:self.actionView];
        //[self addSubview:self.lwButton10];
        //[self addSubview:self.lwButton15];
        //[self addSubview:self.lwButton20];
        //[self addSubview:self.lwButton25];
        //[self addSubview:self.lwButton30];
    }
    return self;
}

- (void) layoutCloseButton:(UIButton *)button {
    UIImage *closeWindowButtonImg = [UIImage imageNamed:@"取消"];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = CGPointMake( [CloverScreen getHorizontal:30] + (closeWindowButtonImg.size.width/2.0) , CGRectGetMaxY(self.bounds) - [CloverScreen getVertical:30] - (closeWindowButtonImg.size.height/2.0) );
    [button setImage:closeWindowButtonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeWindowFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void) layoutConfigButton:(UIButton *)button {
    UIImage *buttonImg = [UIImage imageNamed:@"确定"];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = CGPointMake(  CGRectGetMaxX(self.bounds) - [CloverScreen getHorizontal:30] - (buttonImg.size.width/2.0) , CGRectGetMaxY(self.bounds) - [CloverScreen getVertical:30] - (buttonImg.size.height/2.0) );
    [button setImage:buttonImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(configWindowFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(void) openAnimateFinished
{
    [super openAnimateFinished];
    self.lineWidthBuffer = self.lineWidth;
    [self.showView showLineWidth:self.lineWidth];
    UIImage *openImg = [UIImage imageNamed:@"点击-线条-0"];
    [self.touchButton setImage:openImg forState:UIControlStateNormal];
}

-(void) closeAnimateFinished
{
    [super closeAnimateFinished];
    UIImage *openImg = [UIImage imageNamed:@"线条"];
    [self.touchButton setImage:openImg forState:UIControlStateNormal];
}

- (void) closeWindowFoo:(id)sender {
    [self showViewAtParentView];
    [self.blurView showViewAtParentView];
    [self.showView showViewAtParentView];
    [self.blurBGView showViewAtParentView];
    self.lineWidthSlider.value = self.lineWidthBuffer;
    [self.showView showLineWidth:self.lineWidthSlider.value];
}

- (void) configWindowFoo:(id)sender {
    self.lineWidth = self.lineWidthSlider.value;
    float sendlw = self.lineWidth;
    NSValue *sendValue = [NSValue valueWithBytes:&sendlw objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"com.clover.cutImageWidthIS" object:sendValue];
    [self showViewAtParentView];
    [self.blurView showViewAtParentView];
    [self.showView showViewAtParentView];
    [self.blurBGView showViewAtParentView];
}


- (void) layoutAndSetSlider:(UISlider *)slier andRefRect:(CGRect) refRect {
    //slier.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(refRect));
    slier.minimumTrackTintColor = [CloverScreen stringTOColor:@"c551df"];
    slier.minimumValue = 1.0;
    slier.maximumValue = 100.0;
    slier.value = self.lineWidth;
    [slier addTarget:self action:@selector(sliderMoveDrawWidthShowView:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:slier];
}

/**
 *  获取slider变化，用于绘制showView中的图形
 *
 *  @param sender 传入slider
 */
- (void)sliderMoveDrawWidthShowView:(id)sender {
    UISlider *sli = (UISlider *)sender;
    [self.showView showLineWidth:sli.value];
}

/**
 *  以下程序暂时没用了，因为修改线宽的操作方法变了
 */
-(void) changeLineWidth10:(id)sender{
    self.lineWidth = 10;
    CGPoint center =  CGPointMake(self.lwButton10.center.x, self.lwButton10.center.y);
    CGRect toRect = CGRectMake(center.x - ((self.lineWidth + self.actionEdge )/2), center.y - ((self.lineWidth+self.actionEdge)/2), self.lineWidth + self.actionEdge, self.lineWidth + self.actionEdge );
    [self viewChangeAnimationToRect:toRect andTargerCenter:center];
    
    float sendValue = self.lineWidth;
    NSValue *myValue = [NSValue valueWithBytes:&sendValue objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cutImageSetLineWidth" object:myValue];
}
-(void) changeLineWidth15:(id)sender{
    self.lineWidth = 15;
    CGPoint center =  CGPointMake(self.lwButton15.center.x, self.lwButton15.center.y);
    CGRect toRect = CGRectMake(center.x - ((self.lineWidth + self.actionEdge )/2), center.y - ((self.lineWidth+self.actionEdge)/2), self.lineWidth + self.actionEdge, self.lineWidth + self.actionEdge );
    [self viewChangeAnimationToRect:toRect andTargerCenter:center];
    float sendValue = self.lineWidth;
    NSValue *myValue = [NSValue valueWithBytes:&sendValue objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cutImageSetLineWidth" object:myValue];
}
-(void) changeLineWidth20:(id)sender{
    self.lineWidth = 20;
    CGPoint center =  CGPointMake(self.lwButton20.center.x, self.lwButton20.center.y);
    CGRect toRect = CGRectMake(center.x - ((self.lineWidth + self.actionEdge )/2), center.y - ((self.lineWidth+self.actionEdge)/2), self.lineWidth + self.actionEdge, self.lineWidth + self.actionEdge );
    [self viewChangeAnimationToRect:toRect andTargerCenter:center];
    float sendValue = self.lineWidth;
    NSValue *myValue = [NSValue valueWithBytes:&sendValue objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cutImageSetLineWidth" object:myValue];
}
-(void) changeLineWidth25:(id)sender{
    self.lineWidth = 25;
    CGPoint center =  CGPointMake(self.lwButton25.center.x, self.lwButton25.center.y);
    CGRect toRect = CGRectMake(center.x - ((self.lineWidth + self.actionEdge )/2), center.y - ((self.lineWidth+self.actionEdge)/2), self.lineWidth + self.actionEdge, self.lineWidth + self.actionEdge );
    [self viewChangeAnimationToRect:toRect andTargerCenter:center];
    float sendValue = self.lineWidth;
    NSValue *myValue = [NSValue valueWithBytes:&sendValue objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cutImageSetLineWidth" object:myValue];
}
-(void) changeLineWidth30:(id)sender{
    self.lineWidth = 30;
    CGPoint center =  CGPointMake(self.lwButton30.center.x, self.lwButton30.center.y);
    CGRect toRect = CGRectMake(center.x - ((self.lineWidth + self.actionEdge )/2), center.y - ((self.lineWidth+self.actionEdge)/2), self.lineWidth + self.actionEdge, self.lineWidth + self.actionEdge );
    [self viewChangeAnimationToRect:toRect andTargerCenter:center];
    float sendValue = self.lineWidth;
    NSValue *myValue = [NSValue valueWithBytes:&sendValue objCType:@encode(float)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cutImageSetLineWidth" object:myValue];
}

-(void) viewChangeAnimationToRect:(CGRect)targetRect andTargerCenter:(CGPoint) targetCenter
{
    //    CGRect toRect = CGRectMake(targetRect.origin.x -2, targetRect.origin.y - 2 , targetRect.size.width+2, targetRect.size.height+2);
    CGPoint midPoint;
    if(targetCenter.x > self.actionView.center.x){
        midPoint = CGPointMake(self.actionView.center.x+((targetCenter.x - self.actionView.center.x)/2), self.actionView.center.y );
    }
    else{
        midPoint = CGPointMake(targetCenter.x+((self.actionView.center.x - targetCenter.x)/2), self.actionView.center.y );
    }
    
    float midW = 4;
    float midH = 4;
    
    CGRect midRect = CGRectMake(midPoint.x - midW, midPoint.y - midH,midW , midH);
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.actionView.frame = midRect;
                         [self.actionView.layer setCornerRadius:midRect.size.width/2];
                     }
                     completion:^( BOOL finished ){
                         
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              self.actionView.frame = targetRect;
                                              [self.actionView.layer setCornerRadius:targetRect.size.width/2];
                                          }
                                          completion:^( BOOL finished ){
                                          }];
                     }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
