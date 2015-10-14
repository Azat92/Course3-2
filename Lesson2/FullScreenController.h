//
//  FullScreenController.h
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullScreenProtocol
-(void)offBlock;
@end


@interface FullScreenController : UIViewController

@property (nonatomic, strong) UIImage * albumImage;
@property (nonatomic, weak) id <FullScreenProtocol> delegate;

@end
