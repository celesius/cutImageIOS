//
//  TopViewWithButton.h
//  cutImageIOS
//
//  Created by vk on 15/10/19.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewWithButtonDelegate <NSObject>

- (void)redoButtonTouch;
- (void)undoButtonTouch;

@end

@interface TopViewWithButton : UIView

- (id)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id<TopViewWithButtonDelegate> delegate;
@end
