//
//  StickyHeadersLayout.m
//  Sticky Headers
//
//  Created by FNNishipu on 10/6/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "StickyHeadersLayout.h"

@implementation StickyHeadersLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *headersNeedingLayout = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *att in layoutAttributes)
    {
        if (att.representedElementCategory == UICollectionElementCategoryCell)
        {
//            NSLog(@"att.indexPath.section %zd", att.indexPath.section);
            [headersNeedingLayout addIndex:att.indexPath.section];
//            NSLog(@"headersNeedingLayout1 %zd", headersNeedingLayout.count);
        }
    }
    
    for (UICollectionViewLayoutAttributes *att in layoutAttributes)
    {
        if (att.representedElementKind == UICollectionElementKindSectionHeader)
        {
//            NSLog(@"att.indexPath.section2 %zd", att.indexPath.section);
            [headersNeedingLayout removeIndex:att.indexPath.section];
//            NSLog(@"headersNeedingLayout2 %zd", headersNeedingLayout.count);
        }
    }

//    NSLog(@"headersNeedingLayout3 %zd", headersNeedingLayout.count);

    [headersNeedingLayout enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"idx %zd", idx);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [layoutAttributes addObject:att];
    }];
    
    for (UICollectionViewLayoutAttributes *att in layoutAttributes)
    {
        if (att.representedElementKind == UICollectionElementKindSectionHeader)
        {
            NSInteger section = att.indexPath.section;
            
            UICollectionViewLayoutAttributes *attributesForFirstItemInSection = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *attributesForLastItemInSection = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:section] - 1 inSection:section]];
            
            CGRect frame = att.frame;
            CGFloat offset = self.collectionView.contentOffset.y;
            
            NSLog(@"section %zd, frame %@", section, NSStringFromCGRect(frame));
            
            CGFloat minY = CGRectGetMinY(attributesForFirstItemInSection.frame) - frame.size.height;
            CGFloat maxY = CGRectGetMaxY(attributesForLastItemInSection.frame) - frame.size.height;
            
            NSLog(@"minY %f, maxY %f", minY, maxY);
            
            NSLog(@"offset %f, max %f", offset, MAX(offset, minY));

            CGFloat y = MIN(MAX(offset, minY), maxY);
            
            NSLog(@"yyyyyyyyyyyy %f", y);
            
            frame.origin.y = y;
            
            att.frame = frame;
            att.zIndex = 99;
        }
    }
    
    return layoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end






















