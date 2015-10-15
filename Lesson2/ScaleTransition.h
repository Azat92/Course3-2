//
//  ScaleTransition.h
//  Lesson2
//
//  Created by Gena on 11.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface ScaleTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation;

@end
