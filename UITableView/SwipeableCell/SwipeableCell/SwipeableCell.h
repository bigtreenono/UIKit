//
//  SwipeableCell.h
//  SwipeableCell
//
//  Created by Jeff on 12/26/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItemText:(NSString *)itemText;
- (void)buttonTwoActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface SwipeableCell : UITableViewCell

@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;

@property (nonatomic, strong) NSString *itemText;

- (void)openCell;

@end
