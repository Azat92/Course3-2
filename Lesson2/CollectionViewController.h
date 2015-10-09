//
//  ViewController.h
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenController.h"
#import "DetailViewController.h"

@interface CollectionViewController : UICollectionViewController
                    <FullScreenProtocol,DetailViewProtocol>


@end

