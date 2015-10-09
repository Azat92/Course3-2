//
//  PopTransition.m
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//
#import "PopTransition.h"

#import "CollectionViewController.h"
#import "DetailViewController.h"


@implementation PopTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    DetailViewController *fromViewController = (DetailViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CollectionViewController *toViewController = (CollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGPoint fromCenter = fromViewController.view.center;
    fromCenter.x += fromViewController.view.frame.size.width;
    
    CGPoint toCenter = toViewController.view.center;
    toViewController.view.center = CGPointMake(toCenter.x - 0.3*toViewController.view.frame.size.width, toCenter.y);
    //    toViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    //usingSpringWithDamping:0.8 initialSpringVelocity:1.0
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromViewController.view.center = fromCenter;
        toViewController.view.center = toCenter;
        //        toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
