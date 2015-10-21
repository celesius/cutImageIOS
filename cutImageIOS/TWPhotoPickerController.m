//
//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//  添加下一级的View跳转
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "TWPhotoPickerController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWImageScrollView.h"
#import "CustomPopAnimation.h"
#import "CustomPushAnimation.h"
#import "CutNailViewController.h"
#import <Foundation/Foundation.h>

@interface TWPhotoPickerController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat beginOriginY;
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIImageView *maskView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) CustomPopAnimation *customPopAnimation;
@property (strong, nonatomic) CustomPushAnimation *customPushAnimation;
@property (strong, nonatomic) UIView *dragView;
@property (strong, nonatomic) UIView *navView;

@property (assign, nonatomic) CGPoint pushVCReturnPoint;

@property (assign, nonatomic) CGRect sendViewRect;

@property (strong, nonatomic) CutNailViewController *cutNailViewController;

@end

@implementation TWPhotoPickerController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.collectionView belowSubview:self.topView];
   
    /*
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    */
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customPopAnimation = [[CustomPopAnimation alloc]init];
    self.customPushAnimation = [[CustomPushAnimation alloc]initWithIsFromViewHiddenStatusBar:[self prefersStatusBarHidden]];
    // Do any additional setup after loading the view.
    [self loadPhotos];
}
/**
 *  自定义跳转动画
 *
 *  @param navigationController <#navigationController description#>
 *  @param operation            <#operation description#>
 *  @param fromVC               <#fromVC description#>
 *  @param toVC                 <#toVC description#>
 *
 *  @return <#return value description#>
 */

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation :(UINavigationControllerOperation) operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *) toVC
{
    /**
     *  typedef NS_ENUM(NSInteger, UINavigationControllerOperation) {
     *     UINavigationControllerOperationNone,
     *     UINavigationControllerOperationPush,
     *     UINavigationControllerOperationPop,
     *  };
     */
    //push的时候用我们自己定义的customPush
    if ( operation == UINavigationControllerOperationPush ) {
        return self.customPushAnimation;//customPush ;
    } else if ( operation == UINavigationControllerOperationPop){
        return self.customPopAnimation;
    } else {
        return nil ;
    }
}


- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)loadPhotos {
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos]; //[ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (self.assets.count) {
                UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:0] defaultRepresentation] fullResolutionImage]];
                [self.imageScrollView displayImage:image];
            }
            [self.collectionView reloadData];
        }
        
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIView *)topView {
    if (_topView == nil) {
        CGFloat handleHeight = 44.0f;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (CGRectGetWidth(self.view.bounds)/3)*4 + handleHeight*2);
        //CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor clearColor];
        self.topView.clipsToBounds = YES;
        
        rect = CGRectMake(0, 0, CGRectGetWidth(self.topView.bounds), handleHeight);
        self.navView = [[UIView alloc] initWithFrame:rect];//26 29 33
        self.navView.backgroundColor = [[UIColor colorWithRed:26.0/255 green:29.0/255 blue:33.0/255 alpha:1] colorWithAlphaComponent:.8f];
        [self.topView addSubview:self.navView];
        
        rect = CGRectMake(0, 0, 60, CGRectGetHeight(self.navView.bounds));
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = rect;
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:backBtn];
        
        rect = CGRectMake((CGRectGetWidth(self.navView.bounds)-100)/2, 0, 100, CGRectGetHeight(self.navView.bounds));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.text = @"照片选择";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self.navView addSubview:titleLabel];
        
        rect = CGRectMake(CGRectGetWidth(self.navView.bounds)-80, 0, 80, CGRectGetHeight(self.navView.bounds));
        UIButton *cropBtn = [[UIButton alloc] initWithFrame:rect];
        [cropBtn setTitle:@"OK" forState:UIControlStateNormal];
        [cropBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cropBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [cropBtn addTarget:self action:@selector(cropAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:cropBtn];
        self.pushVCReturnPoint = cropBtn.center;
       
        rect = CGRectMake(0, CGRectGetHeight(self.topView.bounds)-handleHeight, CGRectGetWidth(self.topView.bounds), handleHeight);
        self.dragView = [[UIView alloc] initWithFrame:rect];
        self.dragView.backgroundColor = self.navView.backgroundColor;
        self.dragView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.topView addSubview:self.dragView];
        
        UIImage *img = [UIImage imageNamed:@"cameraroll-picker-grip"];
        rect = CGRectMake((CGRectGetWidth(self.dragView.bounds)-img.size.width)/2, (CGRectGetHeight(self.dragView.bounds)-img.size.height)/2, img.size.width, img.size.height);
        UIImageView *gripView = [[UIImageView alloc] initWithFrame:rect];
        gripView.image = img;
        [self.dragView addSubview:gripView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self.dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        rect = CGRectMake(0, handleHeight, CGRectGetWidth(self.topView.bounds), CGRectGetHeight(self.topView.bounds)-handleHeight*2);
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
       
        self.maskView = [[UIImageView alloc] initWithFrame:rect];
        self.maskView.image = [UIImage imageNamed:@"straighten-grid"];
        [self.topView insertSubview:self.maskView aboveSubview:self.imageScrollView];
       
      //  UIImageView *test = [[UIImageView alloc]initWithFrame:rect];
      //  test.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
      //  [self.topView insertSubview:test aboveSubview:self.imageScrollView];
        
        //PhotoPickerMaskView *mymaskView = [[PhotoPickerMaskView alloc]initWithFrame:rect andCutReduceRate:0.2];
        //[mymaskView setNeedsDisplay];
        //[self.topView insertSubview:mymaskView aboveSubview:self.imageScrollView];
        
        NSString *rectString = NSStringFromCGRect(rect);
        NSLog(@" rectString = %@",rectString);
        
    }
    return _topView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat colum = 4.0, spacing = 2.0;
        CGFloat value = floorf((CGRectGetWidth(self.view.bounds) - (colum - 1) * spacing) / colum);
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(value, value);
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing      = spacing;
        layout.minimumLineSpacing           = spacing;
        
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.topView.bounds));
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[TWPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCell"];
        
//        rect = CGRectMake(0, 0, 60, layout.sectionInset.top);
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = rect;
//        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//        [_collectionView addSubview:backBtn];
//        
//        rect = CGRectMake((CGRectGetWidth(_collectionView.bounds)-140)/2, 0, 140, layout.sectionInset.top);
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
//        titleLabel.text = @"CAMERA ROLL";
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.backgroundColor = [UIColor clearColor];
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
//        [_collectionView addSubview:titleLabel];
    }
    return _collectionView;
}

- (void)backAction {
//    [self dismissViewControllerAnimated:YES completion:NULL];
    self.navigationController.delegate = self;
    [self.customPopAnimation setEndPoint:self.returnPoint];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cropAction {
    if (self.cropBlock) {
        self.cropBlock(self.imageScrollView.capture);
        
        self.navigationController.delegate = self;
        self.cutNailViewController = [[CutNailViewController alloc]init];
        [self.cutNailViewController setCreatNailRootVC:self.creatNailRootVC];
        [self.cutNailViewController setEditImage:self.imageScrollView.capture];
        [self.cutNailViewController setReturnPoint:self.pushVCReturnPoint];
        [self.customPushAnimation setStartPoint:self.pushVCReturnPoint];
        //[self.navigationController pushViewController:cutNailViewController animated:NO]; //jiangbo test
       
        CGPoint topPoint = CGPointMake(0, -44);
        [self viewHiddenAnimationOnView:self.navView animationDurationTime:0.4 andHiddenPoint:topPoint];
        [self viewHiddenAnimationOnView:self.dragView animationDurationTime:0.4 andscalaTo:0.1];
        [self viewHiddenAnimationOnView:self.imageScrollView animationDurationTime:0.4 andscalaTo:1.5];

        CGRect mainScreen = [UIScreen mainScreen].bounds;
        CGPoint bottomPoint = CGPointMake(0, CGRectGetMaxY(mainScreen));
        //[self viewHiddenAnimationOnView:self.dragView animationDurationTime:0.8 andHiddenPoint:bottomPoint];
//        [self viewHiddenAnimationOnView:self.collectionView animationDurationTime:0.4 andHiddenPoint:bottomPoint];
        [self viewPush:self.cutNailViewController hiddenAnimationOnView:self.collectionView animationDurationTime:0.4 andHiddenPoint:bottomPoint];
        
    }
    //[self backAction];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -(CGRectGetHeight(self.topView.bounds)-20-44);
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
            }
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)-20-44))) {
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
    
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame);
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.collectionView.frame = collectionFrame;
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TWPhotoCollectionViewCell";
    
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:[[self.assets objectAtIndex:indexPath.row] thumbnail]];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullScreenImage]];
    [self.imageScrollView displayImage:image];
    if (self.topView.frame.origin.y != 0) {
        [self tapGestureAction:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"velocity:%f", velocity.y);
    if (velocity.y >= 2.0 && self.topView.frame.origin.y == 0) {
        [self tapGestureAction:nil];
    }
}

- (void) viewHiddenAnimationOnView:(UIView *)hiddenView  animationDurationTime:(NSTimeInterval) time andHiddenPoint:(CGPoint) hiddenPoint{
    NSLog(@"Animation Start");
    CGRect bufferRect = hiddenView.frame;
    [UIView animateWithDuration:time
                     animations:^{
                         hiddenView.frame = CGRectMake(hiddenPoint.x, hiddenPoint.y, CGRectGetWidth(hiddenView.frame), CGRectGetHeight(hiddenView.frame));
                     }
                     completion:^(BOOL finished){
                         hiddenView.frame = bufferRect;
                     }];
}

- (void) viewPush:(CutNailViewController*)pushVC  hiddenAnimationOnView:(UIView *)hiddenView  animationDurationTime:(NSTimeInterval) time andHiddenPoint:(CGPoint) hiddenPoint{
    NSLog(@"Animation Start");
    CGRect bufferRect = hiddenView.frame;
    [UIView animateWithDuration:time
                     animations:^{
                         hiddenView.frame = CGRectMake(hiddenPoint.x, hiddenPoint.y, CGRectGetWidth(hiddenView.frame), CGRectGetHeight(hiddenView.frame));
                     }
                     completion:^(BOOL finished){
                         hiddenView.frame = bufferRect;
                         [self.navigationController pushViewController:pushVC animated:NO]; //jiangbo test
                     }];
}

- (void) viewHiddenAnimationOnView:(UIView *)hiddenView  animationDurationTime:(NSTimeInterval) time  andscalaTo:(float)scala{
    NSLog(@"Animation Start");
    CGAffineTransform atf = hiddenView.transform;
    [UIView animateWithDuration:time
                     animations:^{
                         //hiddenView.frame = CGRectMake(hiddenPoint.x, hiddenPoint.y, CGRectGetWidth(hiddenView.frame), CGRectGetHeight(hiddenView.frame));
                         hiddenView.transform = CGAffineTransformMake(scala, 0, 0, scala, 0, 0);
                         if(scala < 1.0)
                             hiddenView.alpha = 0.1;
                     }
                     completion:^(BOOL finished){
                         if(scala > 1.0){
                             [self.cutNailViewController setReceiveImgRect: hiddenView.frame];
                         }
                         hiddenView.transform = atf;
                         hiddenView.alpha = 1;
                     }];
}


@end

