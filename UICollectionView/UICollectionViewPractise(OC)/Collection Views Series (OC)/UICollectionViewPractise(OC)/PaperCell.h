//
//  PaperCell.h
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/18/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Paper;
@class GradientView;

@interface PaperCell : UICollectionViewCell

@property (nonatomic, strong) Paper *paper;

@property (weak, nonatomic) IBOutlet GradientView *gradientView;

@property (weak, nonatomic) IBOutlet UILabel *caption;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (nonatomic, strong) UIView *snapshot;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) BOOL moving;

@end
