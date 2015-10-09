//
//  ViewController.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomCollectionViewCell.h"
#import "RoundCollectionViewLayout.h"
#import "Extensions.h"
#import "ZoomInteractiveTransition.h"
#import "ZoomTransitionProtocol.h"
#import "DetailViewController.h"
#import <BlocksKit+UIKit.h>

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout, ZoomTransitionProtocol>

@property (nonatomic, readonly) NSArray *albums;
@property (nonatomic) BOOL isLayoutCustom;

@property (nonatomic, strong) UIPinchGestureRecognizer *gesture;
@property (nonatomic, strong) CustomCollectionViewCell * selectedCell;
@property (nonatomic, strong) NSIndexPath * selectedPath;

@property (nonatomic, strong) ZoomInteractiveTransition * transition;
@property (nonatomic) BOOL isBlocked;
@end

@implementation CollectionViewController
@synthesize albums = _albums;


-(void)offBlock{
    _isBlocked = NO;
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
    
    _isBlocked = NO;
    self.transition = [[ZoomInteractiveTransition alloc] initWithNavigationController:self.navigationController];
    _gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [_gesture setDelegate:self];
    [_gesture setCancelsTouchesInView:YES];
    [self.collectionView addGestureRecognizer:self.gesture];
    
    NSMutableArray *tempAlbums = [NSMutableArray new];
    NSInteger sections = [self numberOfSectionsInCollectionView:self.collectionView];
    for (int i=0; i<sections; i++) {
        NSMutableArray *sectionAlbums = [NSMutableArray new];
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j=0; j<items; j++) {
            NSString *name = [NSString stringWithFormat:@"%d",arc4random_uniform(18)];
            [sectionAlbums addObject:[UIImage imageNamed:name]];
        }
        [tempAlbums addObject:[NSArray arrayWithArray:sectionAlbums]];
    }
    _albums = [NSArray arrayWithArray:tempAlbums];
}

- (void)didReceivePinchGesture:(UIPinchGestureRecognizer*)gesture{
    NSLog(@"%@", @"RECIEVE");
    if (([gesture numberOfTouches] != 2)
        || _isBlocked) return;
    
    CGPoint p1 = [gesture locationInView:self.collectionView];
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:p1];
    CustomCollectionViewCell *selectedCell = (CustomCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    if (selectedCell) {
        _selectedCell = selectedCell;
        _isBlocked = YES;
        [self performSegueWithIdentifier:@"fullScreen" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"fullScreen"]) {
        FullScreenController *destination = segue.destinationViewController;
        destination.delegate = self;
        destination.albumImage = _selectedCell.imageView.image;
    } else {
        DetailViewController *destination = segue.destinationViewController;
        NSString *text = [NSString stringWithFormat:@"Section:%li, row:%li",(long)_selectedPath.section, _selectedPath.row];
        destination.text = text;
        _selectedPath = nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"SELECT: %ld", (long)indexPath.row);
    _selectedPath = indexPath;
    CustomCollectionViewCell *selectedCell = (CustomCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"detail" sender:selectedCell];
}


-(UIView *)viewForZoomTransition:(BOOL)isSource
{
    return _selectedCell.imageView;
}

- (IBAction)layoutDidClick:(id)sender {
    self.isLayoutCustom = !self.isLayoutCustom;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self numberOfSectionsInCollectionView:self.collectionView]==0)
        return 0;
    switch (section) {
        case 0:
            return 6;
        case 1:
            return 10;
        default:
            break;
    }
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellIdentifier" forIndexPath:indexPath];
    
    UIImage *cellImage = [[_albums objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.imageView setImage:cellImage];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}



@end
