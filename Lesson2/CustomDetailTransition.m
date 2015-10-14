//
//  CustomDetailTransition.m
//  Lesson2
//
//  Created by Артур Сагидулин on 13.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CustomDetailTransition.h"
#import "CollectionViewController.h"
#import "DetailViewController.h"

#define kDuration 1.0

@interface CustomDetailTransition ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic) UINavigationControllerOperation operation;
@property (nonatomic) CGRect finalFrame;

@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, weak) UIView *containerView;

@end

@implementation CustomDetailTransition

-(BOOL)isPush{
    return _operation == UINavigationControllerOperationPush;
}


+ (instancetype)customTransitionWithOperation:(UINavigationControllerOperation)op{
    CustomDetailTransition *transition = [CustomDetailTransition new];
    transition.operation = op;
    return transition;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:toView];
    
    CGFloat frameWidth = toVC.view.frame.size.width;
    
    CGRect finalFrameForToVC = [transitionContext finalFrameForViewController:toVC];
    

    if ([self isPush]) toView.transform = CGAffineTransformMakeTranslation(frameWidth, 0);
    
    [UIView animateWithDuration:kDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([self isPush]) {
            toView.transform = CGAffineTransformIdentity;
            fromView.transform = CGAffineTransformMakeTranslation(-frameWidth, 0);
        } else {
            toView.transform = CGAffineTransformIdentity;
            fromView.transform = CGAffineTransformMakeTranslation(frameWidth, 0);
            toView.frame = finalFrameForToVC;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    _transitionContext = transitionContext;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    _finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    _fromVC = fromVC;
    _toVC = toVC;
    
    _fromView = fromView;
    _toView = toView;
    
    UIView *tempContainer = [transitionContext containerView];
    [tempContainer addSubview:fromView];
    [tempContainer addSubview:toView];
    _containerView = tempContainer;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    CGFloat width = _finalFrame.size.width;
    CGFloat currentPos = percentComplete * width;

    _fromView.transform = CGAffineTransformMakeTranslation(currentPos, 0);
    CGFloat toViewX = _toView.frame.origin.x - currentPos;
    if ([self isPush]) {
        _toView.transform = CGAffineTransformMakeTranslation(toViewX, 0);
    } else {
        _toView.transform = CGAffineTransformMakeTranslation(-width + currentPos, 0);
    }
}

- (void)finishInteractiveTransition {
    [UIView animateWithDuration:kDuration animations:^{
        _toView.transform = CGAffineTransformMakeTranslation(0, 0);
        _fromView.transform = CGAffineTransformMakeTranslation(_finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [super finishInteractiveTransition];
        [_transitionContext completeTransition:finished];
    }];
}

- (void)cancelInteractiveTransition {
    [UIView animateWithDuration:kDuration animations:^{
        _fromView.transform = CGAffineTransformMakeTranslation(0, 0);
        _toView.transform = CGAffineTransformMakeTranslation(-_finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [super cancelInteractiveTransition];
        [self.transitionContext completeTransition:NO];
    }];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kDuration;
}


@end
