//
//  ScaleTransition.h
//  Lesson2
//
//  Created by Victor on 14.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ScaleTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation;

@end
