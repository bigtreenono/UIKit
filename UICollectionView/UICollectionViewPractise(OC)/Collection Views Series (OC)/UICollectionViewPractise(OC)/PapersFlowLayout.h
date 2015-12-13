//
//  PapersFlowLayout.h
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/20/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PapersFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *appearingIndexPath;
@property (nonatomic, strong) NSArray *disappearingItemsIndexPaths;

@end
