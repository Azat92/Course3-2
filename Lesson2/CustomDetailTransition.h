//
//  CustomDetailTransition.h
//  Lesson2
//
//  Created by Артур Сагидулин on 13.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDetailTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

+ (instancetype)customTransitionWithOperation:(UINavigationControllerOperation)op;

@end
