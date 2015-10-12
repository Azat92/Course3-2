//
//  DetailViewController.h
//  Lesson2
//
//  Created by Gena on 12.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end
