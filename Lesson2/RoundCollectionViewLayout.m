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



@interface RoundCollectionViewLayout () {
    NSArray *attributes;
    NSArray *sectionAttributes;
    NSArray *angles;
    NSArray *points;
}
@property (nonatomic) CGFloat currentCellScale;
@end

@implementation RoundCollectionViewLayout
#define kItemSize 100
#define kNextSectionOffset 320
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
}

- (NSInteger)numberOfSections {
    return [self.dataSource numberOfSectionsInCollectionView:self.collectionView];
}

-(id<UICollectionViewDataSource>)dataSource{
    return self.collectionView.dataSource;
}

- (void)prepareLayout {
    
    NSInteger cx = self.collectionViewContentSizeM.width / 2;
    NSInteger cy = 150;
    
    NSArray *sections = [self take:[self numberOfSections]];
    attributes = [sections bk_map:^id(NSNumber *sectionIndex) {
        NSArray *itemsInCurrentSection =
        [self take:[self numberOfItemsInSection:[sectionIndex integerValue]]];
        sectionAttributes = [itemsInCurrentSection bk_map:^id(NSNumber *itemIndex) {
            
            
            angles = [itemsInCurrentSection bk_map:^id(NSNumber *index) {
                
                double addAngle = self.collectionView.contentOffset.x / 2. / cx * 360;
                NSNumber *angle = @(360. * [itemIndex integerValue] / itemsInCurrentSection.count + addAngle);
                return angle;
            }];
            
            double a = cx - kItemSize / 3;
            double b = 100;
            points = [angles bk_map:^id(NSNumber *degree) {
                double fi = degreesToRadians([degree doubleValue]);
                double r = a * b / sqrt(b * b * cos(fi) * cos(fi) + a * a * sin(fi) * sin(fi));
                double x = cx + r * cos(fi);
                double y = cy + r * sin(fi) + kNextSectionOffset*sectionIndex.integerValue;
                return [NSValue valueWithCGPoint:CGPointMake(x, y)];
            }];
            
            CGPoint pt = [points[itemIndex.integerValue] CGPointValue];
        
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:itemIndex.integerValue inSection:sectionIndex.integerValue]];
            
            int currentAngle =
            [[angles objectAtIndex:itemIndex.integerValue] intValue];

            double scale = sin(degreesToRadians(currentAngle))* 2/3 + 1;
            // Увеличение
            attr.transform3D = CATransform3DConcat(CATransform3DMakeScale(scale, scale, scale), CATransform3DMakeTranslation(0, 0, scale*10));

            attr.frame = CGRectMake(pt.x - kItemSize / 2 + self.collectionView.contentOffset.x, pt.y - kItemSize / 2, kItemSize,kItemSize);
            return attr;
            
        }];
        return sectionAttributes;
    }];
    
}


- (CGSize)collectionViewContentSizeM {
    
    CGSize size = self.collectionView.frame.size;
    
    if ([self numberOfSections]>1) {
        size.height += 200;
    } else size.height -= 64;
    return size;
}

- (CGSize)collectionViewContentSize {
    CGSize size = self.collectionViewContentSizeM;
    size.width *= 2;
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [attributes[indexPath.section] objectAtIndex:indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSLog(@"ORIGIN X:%f  Y:%f", rect.origin.x,rect.origin.y);
//    NSLog(@"WIDTH: %f", rect.size.width);
    NSMutableArray *attrs = [NSMutableArray new];

    for (NSArray *arr in attributes) {
        for (UICollectionViewLayoutAttributes *atr in arr) {
            [attrs addObject:atr];
        }
    }
    return attrs;
}

@end
