//
//  DynamicBlurView.h
//  cutImageIOS
//
//  Created by vk on 15/10/23.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import "FXBlurView.h"


@protocol DynamicBlurViewDelegate  <NSObject>
-(void) openAnimateFinishedCallBack;
-(void) closeAnimateFinishedCallBack;
@end

@interface DynamicBlurView : FXBlurView


-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times;
-(void) showViewAtParentView;
-(void) openAnimateFinished;
-(void) closeAnimateFinished;

-(void) closeView;

@property (nonatomic, weak) id<DynamicBlurViewDelegate> delegate;

@end
