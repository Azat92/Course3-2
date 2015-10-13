//
//  RoundCollectionViewLayout.m
//  Lesson2
//
//  Created by Azat Almeev on 26.09.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RoundCollectionViewLayout.h"
#import <BlocksKit+UIKit.h>
#import "Extensions.h"

#define kItemSize 100
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

float const NavigationBarHeight = 64.0;

@interface RoundCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation RoundCollectionViewLayout

- (id<UICollectionViewDataSource>)dataSource {
    return self.collectionView.dataSource;
}

- (NSInteger)numberOfSections {
    return [[self dataSource] numberOfSectionsInCollectionView:self.collectionView];
}

- (CGFloat)heightOfSection {
    return 400.0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [[self dataSource] collectionView:self.collectionView numberOfItemsInSection:section];
}

- (void)prepareLayout {
    self.attributes = [NSMutableArray new];
    
    for (int section = 0; section < [self numberOfSections]; section++) {
        CGFloat centerX = [self collectionViewContentSize].width / 4;
        CGFloat height = section * [self heightOfSection] + NavigationBarHeight;
        CGFloat centerY = height + [self heightOfSection] / 2;
        CGFloat addAngle = self.collectionView.contentOffset.x / 2. / centerX * 360;
        
        NSMutableArray *attr = [NSMutableArray new];
        NSArray *items = [self take:[self numberOfItemsInSection:section]];
        NSArray *angles = [items bk_map:^id(NSNumber *index) {
            return @(360. * [index integerValue] / items.count + addAngle);
        }];
        double a = centerX - kItemSize / 2;
        double b = 100;
        
        NSArray *points = [angles bk_map:^id(NSNumber *degree) {
            double fi = degreesToRadians([degree doubleValue]);
            double r = a * b / sqrt(b * b * cos(fi) * cos(fi) + a * a * sin(fi) * sin(fi));
            double x = centerX + r * cos(fi);
            double y = centerY + r * sin(fi);
            return [NSValue valueWithCGPoint:CGPointMake(x, y)];
        }];
        
        [attr addObjectsFromArray: [items bk_map:^id(NSNumber *index) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:index.integerValue inSection:section];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:currentIndexPath];
            
            CGFloat currentAngle = [angles[index.integerValue] floatValue];
            CGFloat scale = sin(degreesToRadians(currentAngle)) * 2/3 + 1;
            CATransform3D scaleTransform = CATransform3DMakeScale(scale, scale, scale);
            CATransform3D translationTransform = CATransform3DMakeTranslation(0, 0, scale);
            CATransform3D transform = CATransform3DConcat(scaleTransform, translationTransform);
            attr.transform3D = transform;
            
            CGPoint pt = [points[index.integerValue] CGPointValue];
            attr.frame = CGRectMake(pt.x - kItemSize / 2 + self.collectionView.contentOffset.x, pt.y - kItemSize / 2, kItemSize, kItemSize);
            return attr;
        }]];
        [self.attributes addObject:attr];
    }
}

- (CGSize)collectionViewContentSize {
    if ([self numberOfSections] == 0) {
        CGSize size = self.collectionView.frame.size;
        size.height -= NavigationBarHeight;
        return size;
    }
    
    CGFloat width = self.collectionView.frame.size.width * 2;
    CGFloat height = [self numberOfSections] * [self heightOfSection] + NavigationBarHeight;
    return CGSizeMake(width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.attributes[indexPath.section][indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect {
    CGFloat originY = rect.origin.y;
    CGFloat endY = originY + [self heightOfSection];
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int section = 0; section < [self numberOfSections]; section++) {
        CGFloat sectionOriginY = [self heightOfSection] * section + NavigationBarHeight;
        CGFloat sectionEndY = sectionOriginY + [self heightOfSection];
        if ((sectionOriginY >= originY && sectionEndY <= endY) ||
            (sectionOriginY <= originY && sectionEndY <= endY) ||
            (sectionOriginY >= originY && sectionEndY >= endY)) {
            for (int item = 0; item < [self numberOfItemsInSection:section]; item++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                [indexPaths addObject:indexPath];
            }
        }
    }
    return indexPaths;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    return layoutAttributes;
}

@end
