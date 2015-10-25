//
//  ColorPickerView.m
//  cutImageIOS
//
//  Created by vk on 15/10/12.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "ColorPickerView.h"
#import "ColorPreview.h"
#import "RSOpacitySlider.h"
#import "RSBrightnessSlider.h"
#import "CloverScreen.h"

@interface ColorPickerView()

@property (nonatomic, strong) RSColorPickerView *rscpView;

@property (nonatomic, strong) ColorPreview *colorPreview;
@property (nonatomic, strong) RSBrightnessSlider *brightnessSlider;
@property (nonatomic, strong) RSOpacitySlider *opacitySlider;

@end

@implementation ColorPickerView
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect mainScreen = self.bounds;
        int rscpViewW = [CloverScreen getHorizontal:450];
        int  rscpViewH =   rscpViewW;
        self.rscpView = [[RSColorPickerView alloc] initWithFrame:CGRectMake(0, [CloverScreen getVertical:50], rscpViewW, rscpViewH)];
        self.rscpView.center = CGPointMake( CGRectGetMidX(mainScreen), self.rscpView.center.y );
        
        // Optionally set and force the picker to only draw a circle
        [self.rscpView setCropToCircle:YES]; // Defaults to NO (you can set BG color)
        
        self.rscpView.delegate = self;
        
        // UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 340, 0, 0)];
        self.opacitySlider = [[RSOpacitySlider alloc] initWithFrame:CGRectMake(  (mainScreen.size.width/2) -  (mainScreen.size.width*4/5/2) , CGRectGetMaxY(self.rscpView.frame) + 10,  mainScreen.size.width*4/5 /*320 - (20 + CGRectGetWidth(circleSwitch.frame))*/, 30.0)];
        [self.opacitySlider setColorPicker:self.rscpView];
        
        self.brightnessSlider = [[RSBrightnessSlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.opacitySlider.frame), CGRectGetMaxY(self.opacitySlider.frame) + 10, self.opacitySlider.frame.size.width, self.opacitySlider.frame.size.height)];
        [self.brightnessSlider setColorPicker:self.rscpView];
        
        self.colorPreview = [[ColorPreview alloc]initWithFrame:CGRectMake( self.opacitySlider.frame.origin.x , CGRectGetMaxY(self.brightnessSlider.frame) + 10, CGRectGetWidth(self.opacitySlider.frame), 50)];
        
        self.currentColor = [UIColor whiteColor];
        [self addSubview:self.opacitySlider];
        [self addSubview:self.brightnessSlider];
        [self addSubview:self.rscpView];
        [self addSubview:self.colorPreview];
    }
    return self;
}

-(void)colorPickerDidChangeSelection:(RSColorPickerView *)colorPicker{
    UIColor *color = [colorPicker selectionColor];
    self.currentColor = color;
    self.colorPreview.bgColor = color;
    self.brightnessSlider.value = [colorPicker brightness];
    self.opacitySlider.value = [colorPicker opacity];
    //self.colorPreview.backgroundColor = color;
    [self.colorPreview setNeedsDisplay];
}



@end
