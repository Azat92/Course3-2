//
//  ZoomInteractiveTransition.h
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//


#import "ZoomTransitionProtocol.h"


@interface ZoomInteractiveTransition : UIPercentDrivenInteractiveTransition <UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationController * navigationController;

- (instancetype)initWithNavigationController:(UINavigationController *)nc;

@end
