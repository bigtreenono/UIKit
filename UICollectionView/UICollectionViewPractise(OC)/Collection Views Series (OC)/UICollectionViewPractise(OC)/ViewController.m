//
//  ViewController.m
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/18/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "SwiftModule-swift.h"
#import "DetailViewController.h"
#import "PaperCell.h"
#import "SectionHeaderView.h"
#import "PapersFlowLayout.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet PapersFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) PapersDataSource *paperDataSource;
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;
@property (nonatomic, strong) UIView *snapshot;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPaper:)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    _paperDataSource = [[PapersDataSource alloc] init];
    _count = _paperDataSource.count;
    
    CGFloat width = ScreenWidth / 3.0;
    _collectionViewFlowLayout.itemSize = CGSizeMake(width, width);
    
    [_collectionView registerNib:[UINib nibWithNibName:@"PaperCell" bundle:nil] forCellWithReuseIdentifier:@"PaperCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"SectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView"];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_collectionView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)updateSnapshotView:(CGPoint)center transform:(CGAffineTransform)transform alpha:(CGFloat)alpha
{
    _snapshot.center = center;
    _snapshot.transform = transform;
    _snapshot.alpha = alpha;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (self.editing)
    {
        return;
    }
    
    CGPoint location = [recognizer locationInView:_collectionView];
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            _sourceIndexPath = indexPath;
            PaperCell *cell = (PaperCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            _snapshot = cell.snapshot;
            [self updateSnapshotView:cell.center transform:CGAffineTransformIdentity alpha:0.0];
            [_collectionView addSubview:_snapshot];
            [UIView animateWithDuration:0.25 animations:^{
                [self updateSnapshotView:cell.center transform:CGAffineTransformMakeScale(1.05, 1.05) alpha:0.95];
                cell.moving = YES;
            }];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            _snapshot.center = location;
            [_paperDataSource movePaperAtIndexPath:_sourceIndexPath toIndexPath:indexPath];
            [_collectionView moveItemAtIndexPath:_sourceIndexPath toIndexPath:indexPath];
            _sourceIndexPath = indexPath;
        }
            break;
            
        default:
        {
            PaperCell *cell = (PaperCell *)[_collectionView cellForItemAtIndexPath:_sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                [self updateSnapshotView:cell.center transform:CGAffineTransformIdentity alpha:0.0];
                cell.moving = NO;
            } completion:^(BOOL finished) {
                [_snapshot removeFromSuperview];
                _snapshot = nil;
            }];
            _sourceIndexPath = nil;
        }
            break;
    }
}

- (void)deleteButtonTapped:(UIBarButtonItem *)trashButton
{
    NSArray *indexPaths = _collectionView.indexPathsForSelectedItems;
    
    _collectionViewFlowLayout.disappearingItemsIndexPaths = indexPaths;
    
    [_paperDataSource deleteItemsAtIndexPaths:indexPaths];
    
    [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_collectionView deleteItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        _collectionViewFlowLayout.disappearingItemsIndexPaths = nil;
    }];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = !editing;
    _collectionView.allowsMultipleSelection = editing;
    NSArray *indexPaths = _collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *indexPath in indexPaths)
    {
        [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
        PaperCell *cell = (PaperCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.editing = editing;
    }
    
    if (!editing)
    {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)addPaper:(UIBarButtonItem *)button
{
    NSIndexPath *indexPath = [_paperDataSource indexPathForNewRandomPaper];
    _collectionViewFlowLayout.appearingIndexPath = indexPath;
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_collectionView insertItemsAtIndexPaths:@[ indexPath ]];
    } completion:^(BOOL finished) {
        _collectionViewFlowLayout.appearingIndexPath = nil;
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaperCell" forIndexPath:indexPath];
    cell.paper = [_paperDataSource paperForItemAtIndexPath:indexPath];
    cell.editing = self.editing;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
    headerView.titleLabel.text = [_paperDataSource titleForSectionAtIndexPath:indexPath];
    headerView.image.image = [UIImage imageNamed:headerView.titleLabel.text];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)
    {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTapped:)];
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.navigationController.toolbar.items = @[ left, trashButton, right ];

        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    else
    {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.paper = [_paperDataSource paperForItemAtIndexPath:indexPath];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing && collectionView.indexPathsForSelectedItems.count == 0)
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_paperDataSource numberOfPapersInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _paperDataSource.numberOfSections;
}

@end



























