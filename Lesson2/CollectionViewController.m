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
#import <BlocksKit+UIKit.h>

@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, readonly) NSArray *albums;
@property (nonatomic) BOOL isLayoutCustom;
@end

@implementation CollectionViewController
@synthesize albums = _albums;


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

- (IBAction)layoutDidClick:(id)sender {
    self.isLayoutCustom = !self.isLayoutCustom;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self numberOfSectionsInCollectionView:self.collectionView]==0)
        return 0;
    
    return 12;
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
