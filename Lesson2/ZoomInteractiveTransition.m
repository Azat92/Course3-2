//
//  ZoomInteractiveTransition.m
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//


#import "ZoomInteractiveTransition.h"
#import "UIView+Snapshotting.h"

@interface ZoomInteractiveTransition()

@property (nonatomic, weak) id <UINavigationControllerDelegate> previousDelegate;
@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) BOOL shouldCompleteTransition;


@end

@implementation ZoomInteractiveTransition


- (instancetype)initWithNavigationController:(UINavigationController *)nc {
    if (self = [super init]) {
        self.navigationController = nc;
        self.previousDelegate = nc.delegate;
        nc.delegate = self;
    }
    return self;
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

-(UIImageView *)initialZoomSnapshotFromView:(UIView *)sourceView
                            destinationView:(UIView *)destinationView {
    
    UIImage * fromSnapshot = [sourceView dt_takeSnapshot];
    UIImage * toSnapshot = [destinationView dt_takeSnapshot];
    
    UIImage * animateSnapshot = toSnapshot;
    if (fromSnapshot.size.width>toSnapshot.size.width) {
        animateSnapshot = fromSnapshot;
    }
    UIImageView * sourceImageView = [[UIImageView alloc] initWithImage:animateSnapshot];
    sourceImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return sourceImageView;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController <ZoomTransitionProtocol> * fromVC = (id)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController <ZoomTransitionProtocol> *toVC = (id)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    [containerView addSubview:toView];
    
    UIView * zoomFromView = [fromVC viewForZoomTransition:true];
    UIView * zoomToView = [toVC viewForZoomTransition:false];
    
    UIImageView * animatingImageView = [self initialZoomSnapshotFromView:zoomFromView
                                                         destinationView:zoomToView];
    

    animatingImageView.frame = [zoomFromView.superview convertRect:zoomFromView.frame
                                                            toView:containerView];
    
    fromView.alpha = 1;
    toView.alpha = 0;
    zoomFromView.alpha = 0;
    zoomToView.alpha = 0;
    [containerView addSubview:animatingImageView];
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [toView addGestureRecognizer:pinch];
        
    
    
    [UIView animateKeyframesWithDuration:0.3
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  animatingImageView.frame = [zoomToView.superview convertRect:zoomToView.frame toView:containerView];
                                  fromView.alpha = 0;
                                  toView.alpha = 1;
                                  
                              } completion:^(BOOL finished) {
                                  if ([transitionContext transitionWasCancelled]) {
                                      [toView removeFromSuperview];
                                      [transitionContext completeTransition:NO];
                                      zoomFromView.alpha = 1;
                                  } else {
                                      [fromView removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                      zoomToView.alpha = 1;
                                  }
                                  [animatingImageView removeFromSuperview];
                              }];
}


-(void)handlePinch:(UIPinchGestureRecognizer*)recognizer{
    CGFloat scale = recognizer.scale;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactive = YES;
            self.startScale = scale;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale / self.startScale);
            self.shouldCompleteTransition = (percent > 0.25);
            
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!self.shouldCompleteTransition || recognizer.state == UIGestureRecognizerStateCancelled)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
            self.interactive = NO;
            break;
        default:
            break;
    }

}




- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (!navigationController) {
        return  nil;
    }
    
    if (![fromVC conformsToProtocol:@protocol(ZoomTransitionProtocol)] ||
        ![toVC conformsToProtocol:@protocol(ZoomTransitionProtocol)])
    {
        return nil;
    }
    
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.isInteractive) {
        return self;
    }
    
    return nil;
}

@end
