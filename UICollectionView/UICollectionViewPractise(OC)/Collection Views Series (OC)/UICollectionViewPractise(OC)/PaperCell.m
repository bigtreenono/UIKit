//
//  PaperCell.m
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/18/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "PaperCell.h"
#import "SwiftModule-swift.h"

@implementation PaperCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (_editing)
    {
        _checkImageView.image = [UIImage imageNamed:selected ? @"Checked" : @"Unchecked"];
    }
}

- (void)setPaper:(Paper *)paper
{
    _image.image = [UIImage imageNamed:paper.imageName];
    _caption.text = paper.caption;
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    _caption.hidden = editing;
    _checkImageView.hidden = !editing;
}

- (void)setMoving:(BOOL)moving
{
    CGFloat alpha = moving ? 0.0 : 1.0;
    
    _image.alpha = alpha;
    
    _gradientView.alpha = alpha;
    
    _caption.alpha = alpha;
}

- (UIView *)snapshot
{
    UIView *snapshot = [self snapshotViewAfterScreenUpdates:YES];
    
    CALayer *layer = snapshot.layer;
    layer.masksToBounds = NO;
    layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    layer.shadowRadius = 5.0;
    layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end























