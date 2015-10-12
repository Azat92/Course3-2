//
//  ScaleTransition.m
//  Lesson2
//
//  Created by Gena on 11.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "ScaleTransition.h"

@interface ScaleTransition ()

@property (nonatomic) UINavigationControllerOperation operation;

@end

@implementation ScaleTransition

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation {
    ScaleTransition *scaleTransition = [ScaleTransition new];
    scaleTransition.operation = operation;
    return scaleTransition;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    BOOL push = self.operation == UINavigationControllerOperationPush;
    
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    if (push) {
        toViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1;
        if (push) {
            toViewController.view.transform = CGAffineTransformIdentity;
        } else {
            fromViewController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
}

@end
