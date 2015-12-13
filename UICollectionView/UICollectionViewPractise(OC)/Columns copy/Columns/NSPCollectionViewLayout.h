//
//  MyLayout.h
//  Columns
//
//  Created by FNNishipu on 10/3/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSPLayoutDelegate <NSObject>

@optional

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberItemsPerLineForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section;

@end

@interface NSPCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) id <NSPLayoutDelegate> delegate;

@property (nonatomic, assign) IBInspectable UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign) IBInspectable UIEdgeInsets sectionInset;

@property (nonatomic, assign) IBInspectable CGFloat interitemSpacing;

@property (nonatomic, assign) IBInspectable CGFloat lineSpacing;

@property (nonatomic, assign) IBInspectable NSInteger numberOfItemsPerLine;

@property (nonatomic, assign) IBInspectable CGFloat aspectRatio;

@property (nonatomic, assign) IBInspectable CGFloat headerReferenceLength;

@property (nonatomic, assign) IBInspectable CGFloat footerReferenceLength;

@end

































