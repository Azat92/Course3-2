//
//  CustomCollectionViewCell.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [_pinchRecognizer setDelegate:self];
        NSLog(@"%@", @"INITED");
    }
    return self;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    NSLog(@"%@", @"HANDLE");
}

@end
