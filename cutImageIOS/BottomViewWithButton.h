//
//  BottomViewWithButton.h
//  cutImageIOS
//
//  Created by vk on 15/10/19.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewWithButtonDelegate <NSObject>
- (void)goBackTouch;
- (void)addMaskPointTouch;
- (void)cutImageCutTouch;
- (void)deleteMaskPointTouch;
- (void)nextStepTouch;
@end
@interface BottomViewWithButton : UIView

@property (weak, nonatomic) id<BottomViewWithButtonDelegate> delegate;
@end
