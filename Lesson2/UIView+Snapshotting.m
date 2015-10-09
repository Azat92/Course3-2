//
//  UIView+Snapshotting.m
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//


#import "UIView+Snapshotting.h"

@implementation UIView (Snapshotting)

-(UIImage *)dt_takeSnapshot
{
    // Use pre iOS-7 snapshot API since we need to render views that are off-screen.
    // iOS 7 snapshot API allows us to snapshot only things on screen
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
