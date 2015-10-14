//
//  DetailViewController.m
//  Lesson2
//
//  Created by Gena on 12.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTransition.h"

@interface DetailViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.text = [NSString stringWithFormat:@"Section:%ld item:%ld", self.indexPath.section, self.indexPath.row];
    
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)handlePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    CGFloat progress = [gesture translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [DetailTransition new]; //[[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [DetailTransition transitionWithOperation:operation];
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactivePopTransition;
}


@end
