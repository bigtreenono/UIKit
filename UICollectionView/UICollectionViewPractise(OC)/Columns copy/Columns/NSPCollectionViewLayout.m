//
//  MyLayout.m
//  Columns
//
//  Created by FNNishipu on 10/3/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "NSPCollectionViewLayout.h"

@interface NSPCollectionViewLayout ()

@property (nonatomic, strong) NSMutableDictionary *supplementaryAttributes;

@property (nonatomic, strong) NSMutableArray *cellAttributesBySection;

@property (nonatomic, assign) CGFloat collectionViewContentLength;

@end

@implementation NSPCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    _numberOfItemsPerLine = 1;
    _aspectRatio = 1;
    _sectionInset = UIEdgeInsetsZero;
    _interitemSpacing = 10;
    _lineSpacing = 10;
    _scrollDirection = UICollectionViewScrollDirectionVertical;
    _headerReferenceLength = 0;
    _footerReferenceLength = 0;
}

- (CGSize)collectionViewContentSize
{
    return _scrollDirection == UICollectionViewScrollDirectionVertical ?
            CGSizeMake(self.collectionView.bounds.size.width, _collectionViewContentLength) :
            CGSizeMake(_collectionViewContentLength, self.collectionView.bounds.size.height);
}

- (void)prepareLayout
{
    _collectionViewContentLength = 0;
    
    _cellAttributesBySection = [NSMutableArray array];
    _supplementaryAttributes = [NSMutableDictionary dictionary];
    _supplementaryAttributes[UICollectionElementKindSectionHeader] = [NSMutableDictionary dictionary];
    _supplementaryAttributes[UICollectionElementKindSectionFooter] = [NSMutableDictionary dictionary];
    
    for (int section = 0; section < self.collectionView.numberOfSections; ++section)
    {
        // calculateContentSize
        _collectionViewContentLength += [self contentLengthForSection:section];

        // calculateLayoutAttributes
        NSIndexPath *sectionHeaderFooterIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [self headerAttributesForIndexPath:sectionHeaderFooterIndexPath];
        if (headerAttributes)
        {
            _supplementaryAttributes[UICollectionElementKindSectionHeader][sectionHeaderFooterIndexPath] = headerAttributes;
        }
        
        NSMutableArray *attributes = [NSMutableArray array];
        for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; ++item)
        {
            CGSize cellSize = [self cellSizeInSection:section];
            NSInteger numberOfItemsPerLine = [self numberOfItemsPerLineForSection:section];
            NSInteger rowOfItem = item / numberOfItemsPerLine;
            NSInteger locationInRowOfItem = item % numberOfItemsPerLine;
            
            CGFloat sectionStart = [self startOfSection:section];
            CGFloat headReferenceLength = [self headerLengthForSection:section];
            if (headReferenceLength > 0)
            {
                sectionStart += headReferenceLength;
            }
            UIEdgeInsets sectionInset = [self sectionInsetForSection:section];
            CGFloat lineSpacing = [self lineSpacingForSection:section];
            CGFloat interitemSpacing = [self interitemSpacingForSection:section];
            CGRect frame;
            if (_scrollDirection == UICollectionViewScrollDirectionVertical)
            {
                frame.origin.x = sectionInset.left + locationInRowOfItem * cellSize.width + interitemSpacing * locationInRowOfItem;
                frame.origin.y = sectionInset.top + sectionStart + rowOfItem * cellSize.height + rowOfItem * lineSpacing;
            }
            else
            {
                frame.origin.x = sectionStart + sectionInset.left + rowOfItem * cellSize.width + rowOfItem * lineSpacing;
                frame.origin.y = sectionInset.top + locationInRowOfItem * cellSize.height + locationInRowOfItem * interitemSpacing;
            }
            frame.size = cellSize;
            
            UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            cellAttributes.frame = frame;
            [attributes addObject:cellAttributes];
        }
        [_cellAttributesBySection addObject:attributes];
        
        UICollectionViewLayoutAttributes *footerAttributes = [self footerAttributesForIndexPath:sectionHeaderFooterIndexPath];
        if (footerAttributes)
        {
            _supplementaryAttributes[UICollectionElementKindSectionFooter][sectionHeaderFooterIndexPath] = footerAttributes;
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleAttributes = [NSMutableArray array];
    for (NSArray *sectionAttributes in _cellAttributesBySection)
    {
        for (UICollectionViewLayoutAttributes *attributes in sectionAttributes)
        {
            if (CGRectIntersectsRect(rect, attributes.frame))
            {
                [visibleAttributes addObject:attributes];
            }
        }
    }
    
    [_supplementaryAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *kindKey, NSDictionary *attributesDict, BOOL *stop) {
        [attributesDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *pathKey, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
            if (CGRectIntersectsRect(rect, attributes.frame))
            {
                [visibleAttributes addObject:attributes];
            }
        }];
    }];

    return visibleAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellAttributesBySection[indexPath.section][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return _supplementaryAttributes[elementKind][indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

#pragma mark - private helpers

- (CGFloat)contentLengthForSection:(NSInteger)section
{
    NSInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
    NSInteger numberOfItemsPerLine = [self numberOfItemsPerLineForSection:section];
    NSInteger rowsInSection = itemsInSection / numberOfItemsPerLine + (itemsInSection % numberOfItemsPerLine > 0 ? 1 : 0);
    CGFloat contentLength = (rowsInSection - 1) * [self lineSpacingForSection:section];
    
    UIEdgeInsets sectionInsets = [self sectionInsetForSection:section];
    CGSize cellSize = [self cellSizeInSection:section];
    if (_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        contentLength += sectionInsets.top + sectionInsets.bottom;
        contentLength += rowsInSection * cellSize.height;
    }
    else
    {
        contentLength += sectionInsets.left + sectionInsets.right;
        contentLength += rowsInSection * cellSize.width;
    }
    
    contentLength += [self headerLengthForSection:section];
    contentLength += [self footerLengthForSection:section];
    
    return contentLength;
}

- (CGSize)cellSizeInSection:(NSInteger)section
{
    UIEdgeInsets sectionInsets = [self sectionInsetForSection:section];
    CGFloat interitemSpacing = [self interitemSpacingForSection:section];
    NSInteger numberOfItemsPerLine = [self numberOfItemsPerLineForSection:section];
    CGFloat usableSpaceInSection;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        usableSpaceInSection = self.collectionViewContentSize.width - sectionInsets.left - sectionInsets.right - ((numberOfItemsPerLine - 1) * interitemSpacing);
    }
    else
    {
        usableSpaceInSection = self.collectionViewContentSize.height - sectionInsets.top - sectionInsets.bottom - ((numberOfItemsPerLine - 1) * interitemSpacing);
    }
    
    CGFloat cellLength = usableSpaceInSection / [self numberOfItemsPerLineForSection:section];
    CGFloat aspectRatio = [self aspectRatioForSection:section];
    if (_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        return CGSizeMake(cellLength, 1.0 / aspectRatio * cellLength);
    }
    else
    {
        return CGSizeMake(1.0 / aspectRatio * cellLength, cellLength);
    }
}

- (UICollectionViewLayoutAttributes *)headerAttributesForIndexPath:(NSIndexPath *)path
{
    NSInteger section = path.section;
    CGFloat headerReferenceLength = [self headerLengthForSection:section];
    if (headerReferenceLength == 0)
    {
        return nil;
    }
    CGRect frame;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        frame.origin.x = 0;
        frame.origin.y = [self startOfSection:section];
        frame.size.width = self.collectionViewContentSize.width;
        frame.size.height = headerReferenceLength;
    }
    else
    {
        frame.origin.x = [self startOfSection:section];
        frame.origin.y = 0;
        frame.size.width = headerReferenceLength;
        frame.size.height = self.collectionViewContentSize.height;
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
    attributes.frame = frame;
    return attributes;
}

- (CGFloat)startOfSection:(NSInteger)section
{
    CGFloat startOfSection = 0;
    for (int i = 0; i < section; ++i)
    {
        startOfSection += [self contentLengthForSection:i];
    }
    return startOfSection;
}

- (UICollectionViewLayoutAttributes *)footerAttributesForIndexPath:(NSIndexPath *)path
{
    NSInteger section = path.section;
    CGFloat footerReferenceLength = [self footerLengthForSection:section];
    if (footerReferenceLength == 0)
    {
        return nil;
    }
    CGFloat sectionStart = [self startOfSection:section];
    CGFloat sectionLength = [self contentLengthForSection:section];
    CGFloat footerStart = sectionStart + sectionLength;
    if (footerReferenceLength > 0)
    {
        footerStart -= footerReferenceLength;
    }
    CGRect frame;
    if (_scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        frame.origin.x = 0;
        frame.origin.y = footerStart;
        frame.size.width = self.collectionViewContentSize.width;
        frame.size.height = footerReferenceLength;
    }
    else
    {
        frame.origin.x = footerStart;
        frame.origin.y = 0;
        frame.size.width = footerReferenceLength;
        frame.size.height = self.collectionViewContentSize.height;
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:path];
    attributes.frame = frame;
    return attributes;
}

#pragma mark - protocol methods
- (CGFloat)aspectRatioForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:aspectRatioForItemsInSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self aspectRatioForItemsInSectionAtIndex:section];
    }
    return _aspectRatio;
}

- (NSInteger)numberOfItemsPerLineForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:numberItemsPerLineForSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self numberItemsPerLineForSectionAtIndex:section];
    }
    return _numberOfItemsPerLine;
}

- (CGFloat)footerLengthForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceLengthForFooterInSection:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self referenceLengthForFooterInSection:section];
    }
    return _footerReferenceLength;
}

- (CGFloat)headerLengthForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceLengthForHeaderInSection:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self referenceLengthForHeaderInSection:section];
    }
    return _headerReferenceLength;
}

- (CGFloat)interitemSpacingForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:interitemSpacingForSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self interitemSpacingForSectionAtIndex:section];
    }
    return _interitemSpacing;
}

- (CGFloat)lineSpacingForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:lineSpacingForSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self lineSpacingForSectionAtIndex:section];
    }
    return _lineSpacing;
}

- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return _sectionInset;
}

#pragma mark - setters
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection)
    {
        _scrollDirection = scrollDirection;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset))
    {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing
{
    if (_interitemSpacing != interitemSpacing)
    {
        _interitemSpacing = interitemSpacing;
        [self invalidateLayout];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing)
    {
        _lineSpacing = lineSpacing;
        [self invalidateLayout];
    }
}

- (void)setNumberOfItemsPerLine:(NSInteger)numberOfItemsPerLine
{
    if (_numberOfItemsPerLine != numberOfItemsPerLine)
    {
        _numberOfItemsPerLine = numberOfItemsPerLine;
        [self invalidateLayout];
    }
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    if (_aspectRatio != aspectRatio)
    {
        _aspectRatio = aspectRatio;
        [self invalidateLayout];
    }
}

- (void)setHeaderReferenceLength:(CGFloat)headerReferenceLength
{
    if (_headerReferenceLength != headerReferenceLength)
    {
        _headerReferenceLength = headerReferenceLength;
        [self invalidateLayout];
    }
}

- (void)setFooterReferenceLength:(CGFloat)footerReferenceLength
{
    if (_footerReferenceLength != footerReferenceLength)
    {
        _footerReferenceLength = footerReferenceLength;
        [self invalidateLayout];
    }
}

@end


































