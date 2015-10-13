//
//  DetailViewController.h
//  Lesson2
//
//  Created by Victor on 14.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) NSIndexPath *index;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
