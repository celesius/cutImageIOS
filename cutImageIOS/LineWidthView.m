//
//  LineWidthView.m
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "LineWidthView.h"
#import "DotButton.h"
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


@end

@implementation LineWidthView

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times{
    //if(self = [super init]){
    if(self = [super initWithRect:viewRect andHiddenPoint:hiddenPoint andAnimateDuration:times]){
        self.showRect = viewRect;
        self.lineWidth = 10.0;
        //self.lwButton10 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton15 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton20 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton25 = [DotButton buttonWithType:UIButtonTypeCustom];
        //self.lwButton30 = [DotButton buttonWithType:UIButtonTypeCustom];
        self.actionEdge = ACTIONEDGE;
        
        float lwButtonW = self.frame.size.width/MAXBUTTON;
        float lwButtonH = lwButtonW;
        CGRect lwButtonRect = CGRectMake(0, 0, lwButtonW, lwButtonH);
        
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
       
        
        self.actionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.lineWidth+self.actionEdge, self.lineWidth+self.actionEdge)];
        self.actionView.center = self.lwButton10.center;
        [self.actionView.layer setCornerRadius:self.actionView.frame.size.width/2];
        self.actionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.0 blue:0 alpha:0.9];
       
        
        [self addSubview:self.actionView];
        [self addSubview:self.lwButton10];
        [self addSubview:self.lwButton15];
        [self addSubview:self.lwButton20];
        [self addSubview:self.lwButton25];
        [self addSubview:self.lwButton30];
    }
    return self;
}

-(void) openAnimateFinished
{
    [super openAnimateFinished];
}

-(void) closeAnimateFinished
{
    [super closeAnimateFinished];
}

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
