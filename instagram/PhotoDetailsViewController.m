//
//  PhotoDetailsViewController.m
//  instagram
//
//  Created by Xin Suo on 10/22/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "PhotoDetailsViewController.h"

@interface PhotoDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoDetailImageView;

@end

@implementation PhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *imageUrl = [NSURL URLWithString: self.imageUrlStr];
    [self.photoDetailImageView setImageWithURL:imageUrl];
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
