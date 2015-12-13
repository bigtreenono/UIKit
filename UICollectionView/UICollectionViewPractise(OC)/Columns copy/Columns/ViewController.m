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
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout aspectRatioForItemsInSectionAtIndex:(NSInteger)section
{
    return _layout.numberOfItemsPerLine == 1 ? [UIScreen mainScreen].bounds.size.width / 44 : 0.7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = indexPath.section % 2 ? [UIColor blueColor] : [UIColor redColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 125;
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



























