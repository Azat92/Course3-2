//
//  DetailTransition.h
//  Lesson2
//
//  Created by Gena on 12.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DetailTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithOperation:(UINavigationControllerOperation)operation;

@end
