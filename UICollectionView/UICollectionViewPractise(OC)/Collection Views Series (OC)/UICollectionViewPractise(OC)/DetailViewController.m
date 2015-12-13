//
//  DetailViewController.m
//  UICollectionViewPractise(OC)
//
//  Created by FNNishipu on 8/18/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "DetailViewController.h"
#import "SwiftModule-swift.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageView.image = [UIImage imageNamed:_paper.imageName];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
