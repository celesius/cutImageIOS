//
//  LineWidthShowView.h
//  cutImageIOS
//
//  Created by vk on 15/10/22.
//  Copyright © 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicView.h"
@interface LineWidthShowView : DynamicView

-(id)initWithRect:(CGRect) viewRect andHiddenPoint:(CGPoint) hiddenPoint andAnimateDuration:(NSTimeInterval)times;
- (void) showLineWidth:(float) lineWidth;

@end
