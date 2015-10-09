//
//  DetailViewController.h
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewProtocol
-(void)restoreNavControllerDelegate;
@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString * text;
@property (nonatomic, weak) id <DetailViewProtocol> delegate;

@end
