//
//  FullScreenController.m
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "FullScreenController.h"
#import "ZoomTransitionProtocol.h"

@interface FullScreenController () <ZoomTransitionProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImage:_albumImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [_delegate offBlock];
}


-(UIView *)viewForZoomTransition:(BOOL)isSource {
    return self.imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
