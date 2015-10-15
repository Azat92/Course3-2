//
//  ViewController.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "SnakeCollectionViewLayout.h"
#import "RoundCollectionViewLayout.h"
#import "FullImageViewController.h"
#import "Extensions.h"
#import <BlocksKit+UIKit.h>
#import "ScaleTransition.h"
#import "DetailTransition.h"
#import "DetailViewController.h"
#import <Foundation/Foundation.h>


NSInteger const MaxNumberOfImages = 15;
NSString * const ImageNameFormatString = @"ios-9-wallpapers-%ld";

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate>

@property (nonatomic, readonly) NSArray *colors;
@property (nonatomic) BOOL isLayoutCustom;
@property (nonatomic) CGFloat initialScale;
@property (nonatomic) BOOL showFullImage;

@end

@implementation CollectionViewController
@synthesize colors = _colors;

- (NSArray *)colors {
    if (!_colors)
        _colors = [[self take:[self collectionView:self.collectionView numberOfItemsInSection:0]] bk_map:^id(id obj) {
            return [UIColor randomColor];
        }];
    return _colors;
}

- (void)setIsLayoutCustom:(BOOL)isLayoutCustom {
    _isLayoutCustom = isLayoutCustom;
    if (isLayoutCustom)
        [self.collectionView setCollectionViewLayout:[RoundCollectionViewLayout new] animated:YES];
    else
        [self.collectionView setCollectionViewLayout:[UICollectionViewFlowLayout new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCellIdentifier"];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.collectionView addGestureRecognizer:pinchGesture];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.initialScale = gesture.scale;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat percent = self.initialScale / gesture.scale;
        if (percent > 0.2) {
            self.showFullImage = YES;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.showFullImage) {
            [self performSegueWithIdentifier:@"ShowFullImage" sender:cell.imageView.image];
        }
    }
}

- (IBAction)layoutDidClick:(id)sender {
    self.isLayoutCustom = !self.isLayoutCustom;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UIImage *)imageAtIndex:(NSInteger)index {
    NSInteger imageIndex = index % MaxNumberOfImages + 1;
    NSString *imageName = [NSString stringWithFormat:ImageNameFormatString, imageIndex];
    return [UIImage imageNamed:imageName];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellIdentifier" forIndexPath:indexPath];
    
    cell.imageView.image = [self imageAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDetail" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowFullImage"]) {
        FullImageViewController *destinationVC = segue.destinationViewController;
        destinationVC.image = (UIImage *)sender;
    }
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        DetailViewController *destinationVC = segue.destinationViewController;
        destinationVC.indexPath = (NSIndexPath *)sender;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (([fromVC class] == [FullImageViewController class]) || ([toVC class] == [FullImageViewController class])) {
        return [ScaleTransition transitionWithOperation:operation];
    }
    if (([fromVC class] == [DetailViewController class]) || ([toVC class] == [DetailViewController class])) {
        return [DetailTransition transitionWithOperation:operation];
    }
    
    return nil;
}

@end
