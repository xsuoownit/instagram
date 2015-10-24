//
//  ViewController.m
//  instagram
//
//  Created by Xin Suo on 10/22/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "PhotosViewController.h"
#import "FeedTableViewCell.h"
#import "PhotoDetailsViewController.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;

@property (strong, nonatomic) NSArray *feeds;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Instagram"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Chalkduster" size:21]}];
    UIColor *navigationBarBGColor = [UIColor colorWithRed:60/255.0f green:84/255.0f blue:189/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = navigationBarBGColor;
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    
    self.feedTableView.rowHeight = 320;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:self.refreshControl atIndex:0];
    [self onRefresh];
}

- (void)onRefresh {
    NSString *clientId = @"Use Your Own";
    NSString *urlString =
    [@"https://api.instagram.com/v1/media/popular?client_id=" stringByAppendingString:clientId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.feeds = responseDictionary[@"data"];
                                                    [self.feedTableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                [self.refreshControl endRefreshing];
                                            }];
    [task resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.feeds count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"feedTableViewCell"];
    NSURL *imageUrl = [NSURL URLWithString:self.feeds[indexPath.section][@"images"][@"standard_resolution"][@"url"]];
    [cell.feedImageView setImageWithURL:imageUrl];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    PhotoDetailsViewController *photoDetailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.feedTableView indexPathForCell:sender];
    photoDetailsViewController.imageUrlStr = self.feeds[indexPath.section][@"images"][@"standard_resolution"][@"url"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.feedTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
    
    UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [profileView setClipsToBounds:YES];
    profileView.layer.cornerRadius = 15;
    profileView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.8].CGColor;
    profileView.layer.borderWidth = 1;
    
    // Use the section number to get the right URL
    NSURL *userUrl = [NSURL URLWithString:self.feeds[section][@"user"][@"profile_picture"]];
    [profileView setImageWithURL:userUrl];
    
    [headerView addSubview:profileView];
    
    // Add a UILabel for the username here
    UILabel *profileName = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
    [profileName setText:self.feeds[section][@"user"][@"username"]];
    [headerView addSubview:profileName];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
