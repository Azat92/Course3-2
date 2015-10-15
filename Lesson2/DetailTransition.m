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
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, weak) UIView *leftView;
@property (nonatomic, weak) UIView *rightView;

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
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    
    BOOL push = self.operation == UINavigationControllerOperationPush;
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *leftView = push ? fromView : toView;
    UIView *rightView = push ? toView : fromView;
    
    CGAffineTransform scaledTransform = CGAffineTransformMakeTranslation(-finalFrame.size.width, 0);
    CGAffineTransform shifted = CGAffineTransformMakeTranslation(finalFrame.size.width, 0);
    
    fromView.frame = finalFrame;
    toView.frame = finalFrame;
    
    if (push)
        rightView.transform = shifted;
    else
        leftView.transform = scaledTransform;
    
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (push) {
            leftView.transform = scaledTransform;
            rightView.transform = CGAffineTransformIdentity;
        }
        else {
            leftView.transform = CGAffineTransformIdentity;
            rightView.transform = shifted;
        }
    } completion:^(BOOL finished) {
        leftView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:finished];
    }];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIView *container = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    self.finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    self.leftView = toView;
    self.rightView = fromView;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-self.finalFrame.size.width, 0);
    
    fromView.frame = self.finalFrame;
    toView.frame = self.finalFrame;
    self.leftView.transform = transform;
    
    [container addSubview:self.leftView];
    [container addSubview:self.rightView];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-self.finalFrame.size.width * (1 - percentComplete), 0);
    self.leftView.transform = transform;
    self.rightView.transform = CGAffineTransformMakeTranslation(self.finalFrame.size.width * percentComplete, 0);
}

- (void)finishInteractiveTransition {
    [super finishInteractiveTransition];
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        // смещение вправо
        self.leftView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.rightView.transform = CGAffineTransformMakeTranslation(self.finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.transitionContext completeTransition:finished];
        
    }];
}

- (void)cancelInteractiveTransition {
    [super cancelInteractiveTransition];
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        // смещение влево
        self.rightView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.leftView.transform = CGAffineTransformMakeTranslation(-self.finalFrame.size.width, 0);
    } completion:^(BOOL finished) {
        self.leftView.transform = CGAffineTransformIdentity;
        [self.transitionContext completeTransition:!finished];
    }];
}

@end
