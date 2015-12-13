//
//  ViewController.m
//  Columns
//
//  Created by FNNishipu on 10/3/15.
//  Copyright © 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "HeaderFooterView.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HeaderFooterView class]) bundle:nil];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"supplementaryView"];
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"supplementaryView"];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat inset = 10 * (section + 1);
    
    return UIEdgeInsetsMake(inset, inset, inset, inset);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return (section + 1) * 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return (section + 1) * 10;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout numberItemsPerLineForSectionAtIndex:(NSInteger)section
//{
//    return ((NSPCollectionViewLayout *)self.collectionViewLayout).numberOfItemsPerLine + (section * 1);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section
//{
//    return section + 1;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForHeaderInSection:(NSInteger)section
//{
//    return 20 * (1 + section);
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceLengthForFooterInSection:(NSInteger)section
//{
//    return 20 * (1 + section);
//}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderFooterView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"supplementaryView" forIndexPath:indexPath];
    supplementaryView.title.text = kind;
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = indexPath.section % 2 ? [UIColor blueColor] : [UIColor redColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 25;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (void)changeColumnsTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destructiveButton" otherButtonTitles:@"1", @"2", @"3", @"4", @"5", @"6", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _layout.numberOfItemsPerLine = buttonIndex;
    NSLog(@"%zd", buttonIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end



























