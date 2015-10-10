//
//  DynamicView.h
//  cutImageIOS
//
//  Created by vk on 15/9/24.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicViewDelegate  <NSObject>

-(void) openAnimateFinishedCallBack;
-(void) closeAnimateFinishedCallBack;

@end

@interface DynamicView : UIView

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times;
-(void) showViewAtParentView;
-(void) openAnimateFinished;
-(void) closeAnimateFinished;

@property (nonatomic, weak) id<DynamicViewDelegate> delegate;
@end
