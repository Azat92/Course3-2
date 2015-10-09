//
//  PopTransition.h
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGFloat duration;
@end
