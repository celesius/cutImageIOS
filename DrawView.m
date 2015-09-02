//
//  ImageShowView.m
//  cutImageIOS
//
//  Created by vk on 15/8/31.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "DrawView.h"
#import "DrawViewModel.h"
#import <CoreMotion/CoreMotion.h>

@interface DrawView()

@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;
//@property (strong, nonatomic) UIImage * setImage;
@property (strong, nonatomic) UIImageView * setView;
@property (nonatomic) BOOL moveAction;

@property (strong, nonatomic) NSMutableArray *removePathArray;
@property (strong, nonatomic) CMMotionManager *cmMotionManager;
//@property (nonatomic) float
@property (nonatomic, strong) NSMutableArray *pointArray;  //同时发送的只能有一组array, 删除，添加，选取都是这一个array
@end

@implementation DrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        //self.frame = frame;
        //self.setView = [[UIImageView alloc]initWithFrame:frame];
        //self.setView.backgroundColor = [UIColor yellowColor];
        //[self addSubview:self.setView];
        //[self sendSubviewToBack:self.setView];
        self.lineWidth = 10.0f;
        self.lineColor = [UIColor  colorWithRed:1.0 green:0 blue:0 alpha:0.5];  //[UIColor redColor];
        self.moveAction = NO;
        self.removePathArray = [NSMutableArray array];
        self.pointArray = [NSMutableArray array];
        self.cmMotionManager = [[CMMotionManager alloc]init];
        self.lineScale = 1.0;
    }
    return self;

}
/*
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.appImageView]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
   // if(x >= 0 && x<= self.orgRect.size.width)
    NSLog(@"touch moved (x, y) is (%d, %d)", x, y);
    [self addPoint2Array:point];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.appImageView]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    NSLog(@" ");
    NSLog(@"touch began (x, y) is (%d, %d)", x, y);
    [self.pointArray removeAllObjects];
    [self addPoint2Array:point];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.appImageView]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    NSLog(@"touch ended (x, y) is (%d, %d)", x, y);
    [self addPoint2Array:point];
    
    if(self.isMove == NO){
        if(self.isDelete == NO){
            if(self.isDraw == NO){
                [self.b2opcv setCreatPoint:self.pointArray andLineWidth:self.setLineWidth];
            }
            else{
                [self.b2opcv setDrawPoint:self.pointArray andLineWidth:self.setLineWidth];
            }
        }
        else
        {
            [self.b2opcv setDeletePoint:self.pointArray andLineWidth:self.setLineWidth];
        }
    }
    //UIImage *imgSend = self.appImageView.image;
}
*/

-(void) setPhotoImage:(UIImage *)setImage
{
    //self.setView.image = setImage;
    //self.image = setImage;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
- (void)drawView:(CGContextRef)context
{
    for (DrawViewModel *myViewModel in _pathArray) {
        CGContextAddPath(context, myViewModel.path.CGPath);
        [myViewModel.color set];
        CGContextSetLineWidth(context, myViewModel.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth*self.lineScale);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

-(void) setMove:(BOOL)isMove
{
    self.moveAction = isMove;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.moveAction){
        [self.removePathArray removeAllObjects];
        UITouch *touch = [touches anyObject];
        CGPoint location =[touch locationInView:self];
        _path = CGPathCreateMutable();
        _isHavePath = YES;
        CGPathMoveToPoint(_path, NULL, location.x, location.y);
        
        [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
        
        //NSLog(@"touch began (x, y) is (%f, %f)", location.x, location.y);
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.moveAction){
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    [self setNeedsDisplay];
    [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
    //NSLog(@"touch move (x, y) is (%f, %f)", location.x, location.y);
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.moveAction){
        if (_pathArray == nil) {
            _pathArray = [NSMutableArray array];
        }
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        [self.pointArray addObject: [NSValue valueWithCGPoint:location]];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
        DrawViewModel *myViewModel = [DrawViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth*self.lineScale];
        [_pathArray addObject:myViewModel];
        CGPathRelease(_path);
        _isHavePath = NO;
       /*
        if(self.isMove == NO){
            if(self.isDelete == NO){
                if(self.isDraw == NO){
                    [self.b2opcv setCreatPoint:self.pointArray andLineWidth:self.setLineWidth];
                }
                else{
                    [self.b2opcv setDrawPoint:self.pointArray andLineWidth:self.setLineWidth];
                }
            }
            else
            {
                [self.b2opcv setDeletePoint:self.pointArray andLineWidth:self.setLineWidth];
            }
        }
        */
    }
}

-(void) redo
{
    if(self.pathArray != nil){
        NSLog(@"length = %lu",(unsigned long)self.pathArray.count);
        int sizeOfPathArray = (int)[self.pathArray count];
        if(sizeOfPathArray != 0){
        DrawViewModel *viewModelWillSave = self.pathArray[sizeOfPathArray - 1];
        [self.removePathArray addObject:viewModelWillSave];
        [self.pathArray removeLastObject];
        [self setNeedsDisplay];
        }
    }
}

-(void) undo
{
    if(self.pathArray != nil){
        NSLog(@"length = %lu",(unsigned long)self.pathArray.count);
        if(self.removePathArray.count != 0) //非0时进行后续计算
        {
            int sizeOfRemovePathArray = (int)[self.removePathArray count];
            DrawViewModel *viewModelWillSave = self.removePathArray[sizeOfRemovePathArray - 1];
            [self.pathArray addObject:viewModelWillSave];
            [self.removePathArray removeLastObject];
            [self setNeedsDisplay];
        }
    }
}

@end
