//
//  ColorPickerView.h
//  cutImageIOS
//
//  Created by vk on 15/10/12.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"

@interface ColorPickerView : UIView <RSColorPickerViewDelegate>

- (id)initWithFrame:(CGRect)frame;
- (void) updateLastColor;

@property (nonatomic, strong) UIColor *currentColor;


@end
