//
//  AccountDetailsViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/15/21.
//

#import "AccountDetailsViewController.h"
#import "PathDetailsViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Path.h"
#import "PathCell.h"
#import <Parse/PFImageView.h>
#import <Parse/PFUser.h>

@interface AccountDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPathsLabel;
@property (weak, nonatomic) IBOutlet UITableView *pathsTableView;
@property (strong, nonatomic) NSArray *paths;

@end

@implementation AccountDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.usernameLabel.text = [PFUser currentUser].username;
    self.profileImageView.file = [PFUser currentUser][@"profile_image"];
    [self.profileImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    }];
    self.numberOfPathsLabel.text = [NSString stringWithFormat: @"%@ Paths Created", [PFUser currentUser][@"totalPaths"]];
    [Path getUserPaths:[PFUser currentUser].objectId completion:^(NSArray * _Nonnull paths, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Error loading paths: %@", error.localizedDescription);
        } else {
            self.paths = paths;
            [self.pathsTableView reloadData];
        }
    }];
}

- (void) setupTableView {
    self.pathsTableView.delegate = self;
    self.pathsTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"PathCell" bundle: nil];
    [self.pathsTableView registerNib:nib forCellReuseIdentifier:@"PathCell"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PathCell *cell = [self.pathsTableView dequeueReusableCellWithIdentifier:@"PathCell"];
    Path *path = self.paths[indexPath.row];
    [cell configureCell:path username:[PFUser currentUser].username showUsername: FALSE];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paths.count;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Path *path = self.paths[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PathDetailsViewController *detailsVC = [storyboard instantiateViewControllerWithIdentifier: @"PathDetailsViewController"];
    detailsVC.path = path;
    [self.navigationController pushViewController: detailsVC animated: YES];
}


- (IBAction)didLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            if (error == nil) {
                SceneDelegate *sceneDelegate = (SceneDelegate *) self.view.window.windowScene.delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *LoginVC = [storyboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
                sceneDelegate.window.rootViewController = LoginVC;
            }
    }];
    
}

@end