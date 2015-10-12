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
    UIView *containerView = [transitionContext containerView];
    
    BOOL push = self.operation == UINavigationControllerOperationPush;
    
    [containerView addSubview:toViewController.view];
    CGFloat width = fromViewController.view.frame.size.width;
    
    if (push) {
        toViewController.view.transform = CGAffineTransformMakeTranslation(width, 0);
    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (push) {
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(-width, 0);
        } else {
            toViewController.view.transform = CGAffineTransformIdentity;
            fromViewController.view.transform = CGAffineTransformMakeTranslation(width, 0);
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
}

@end
