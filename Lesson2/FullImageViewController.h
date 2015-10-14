//
//  FullImageViewController.h
//  Lesson2
//
//  Created by Victor on 13.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
