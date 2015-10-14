//
//  DetailViewController.m
//  Lesson2
//
//  Created by Артур Сагидулин on 09.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//


#import "DetailViewController.h"
#import "CollectionViewController.h"
#import "CustomDetailTransition.h"


@interface DetailViewController () <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_label setText:_text];
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
        [_delegate restoreNavControllerDelegate];
    }
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {

    return [CustomDetailTransition customTransitionWithOperation:operation];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {

    return _interactivePopTransition;
}


- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _interactivePopTransition = [CustomDetailTransition new];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {

        [_interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {

        if (progress > 0.5) {
            [_interactivePopTransition finishInteractiveTransition];
        }
        else {
            [_interactivePopTransition cancelInteractiveTransition];
        }
        
        _interactivePopTransition = nil;
    }
    
}



@end
