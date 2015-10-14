//
//  DetailTransition.m
//  Lesson2
//
//  Created by Gena on 12.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "DetailTransition.h"

@interface DetailTransition ()

@property (nonatomic) UINavigationControllerOperation operation;
@property (nonatomic) CGRect finalFrame;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView *containerView;

@end

@implementation DetailTransition

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation {
    DetailTransition *detailransition = [DetailTransition new];
    detailransition.operation = operation;
    return detailransition;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    
    BOOL push = self.operation == UINavigationControllerOperationPush;
    
    [containerView addSubview:toViewController.view];
    
    CGFloat toWidth = toViewController.view.frame.size.width;
    CGFloat fromWidth = fromViewController.view.frame.size.width;
    
    if (push) {
        toViewController.view.transform = CGAffineTransformMakeTranslation(toWidth, 0);
    } else {
//        toViewController.view.transform = CGAffineTransformMakeTranslation(-fromWidth, 0);
//        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_4);
//        CGAffineTransform transform = CGAffineTransformTranslate(rotation, -finalFrame.size.width, 0);
//        toViewController.view.transform = CGAffineTransformTranslate(rotation, -finalFrame.size.width, 0);
//        CGRectApplyAffineTransform(toViewController.view.bounds, transform);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (push) {
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(-fromWidth, 0);
        } else {
            toViewController.view.transform = CGAffineTransformIdentity;
//            toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            fromViewController.view.transform = CGAffineTransformMakeTranslation(finalFrame.size.width, 0);
//            toViewController.view.frame = finalFrame;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *container = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    self.finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    self.fromView = fromView;
    self.toView = toView;
    self.fromViewController = fromVC;
    self.toViewController = toVC;
    
    [container addSubview:fromView];
    [container addSubview:toView];
    self.containerView = container;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    BOOL push = self.operation == UINavigationControllerOperationPush;
    CGFloat position = percentComplete * self.finalFrame.size.width;
    CGFloat width = self.finalFrame.size.width;
    
    self.fromView.transform = CGAffineTransformMakeTranslation(position, 0);
    CGFloat toViewX = self.toView.frame.origin.x;
    if (push) {
        self.toView.transform = CGAffineTransformMakeTranslation(toViewX - position, 0);
    } else {
        self.toView.transform = CGAffineTransformMakeTranslation(-width + position, 0);
    }
}

- (void)finishInteractiveTransition {
    [super finishInteractiveTransition];
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        // смещение вправо
        self.toView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.fromView.transform = CGAffineTransformMakeTranslation(self.finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:finished];
        
    }];
}

- (void)cancelInteractiveTransition {
    [super cancelInteractiveTransition];
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        // смещение влево
        self.fromView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.toView.transform = CGAffineTransformMakeTranslation(-self.finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:!finished];
        
    }];
}

@end
