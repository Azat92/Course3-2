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
#import "Extensions.h"
#import <BlocksKit+UIKit.h>

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, readonly) NSArray *colors;
@property (nonatomic) BOOL isLayoutCustom;
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
}

- (IBAction)layoutDidClick:(id)sender {
    self.isLayoutCustom = !self.isLayoutCustom;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self numberOfSectionsInCollectionView:self.collectionView]==0)
        return 0;
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        return 3;
}

@end
