//
//  NewPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "NewPathViewController.h"
#import "AddLandmarkViewController.h"
#import "EndPathViewController.h"
#import "LandmarkDetailsViewController.h"
#import "NewPathBottomView.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSPolyline.h>
#import <CoreLocation/CoreLocation.h>
#import "Pathway.h"
#import "Path.h"
#import "Landmark.h"

@interface NewPathViewController () <CLLocationManagerDelegate, AddLandMarkViewControllerDelegate, EndPathViewControllerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIButton *addPathButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Pathway *pathway;
@property (strong, nonatomic) Path *path;
@property (strong, nonatomic) NSMutableArray *landmarks;
@property (strong, nonatomic) GMSMutablePath *pathLine;
@property (strong, nonatomic) GMSPolyline *pathpolyline;
@property (strong, nonatomic) NSMutableArray *bottomViewLayoutConstraints;
@property (strong, nonatomic) UIImage *hazardImage;
@property (strong, nonatomic) UIImage *landmarkImage;
@property (nonatomic, assign) BOOL initialZoom;
@property (strong, nonatomic) NSMutableArray *landmarkMarkers;
@property (strong, nonatomic) NewPathBottomView *bottomView;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *maximizedHeightConstraint;

@end

@implementation NewPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.landmarkMarkers = [[NSMutableArray alloc] init];
    self.landmarkImage = [UIImage imageNamed:@"colosseum"];
    self.hazardImage = [UIImage imageNamed:@"wildfire"];
    self.landmarks = [[NSMutableArray alloc] init];
    self.pathway = [Pathway new];
    self.path = [Path new];
    self.path.startedAt = [NSDate now];
    self.path.hazardCount = @(0);
    self.path.landmarkCount = @(0);
    self.initialZoom = FALSE;

    self.navigationController.navigationBarHidden = TRUE;
    [self setUpBottomView];
    [self hideFollowView];
    
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0.0, 0.0, 5 + self.bottomView.frame.size.width /20, 0.0);
    self.gMapView.padding = mapInsets;
    self.pathLine = [GMSMutablePath path];
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    [self.gMapView animateToZoom: 20];
    self.gMapView.delegate = self;
    [self.gMapView animateToLocation: self.gMapView.myLocation.coordinate];

    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 6;
    self.locationManager.allowsBackgroundLocationUpdates = TRUE;
    self.locationManager.pausesLocationUpdatesAutomatically = FALSE;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (IBAction)didSwitchFollow:(id)sender {
    if ([self.followSwitch isOn]) {
        [self.gMapView animateToLocation: self.gMapView.myLocation.coordinate];
        [self.gMapView animateToZoom: 20];
        self.gMapView.settings.scrollGestures = FALSE;
    } else {
        self.gMapView.settings.scrollGestures = TRUE;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"NewPathToHazard"]) {
        AddLandmarkViewController *landmarkVC = (AddLandmarkViewController *) segue.destinationViewController;
        landmarkVC.type = @"Hazard";
        landmarkVC.location = self.locationManager.location;
        landmarkVC.pathId = self.path.objectId;
        landmarkVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"NewPathToLandmark"]) {
        AddLandmarkViewController *landmarkVC = (AddLandmarkViewController *) segue.destinationViewController;
        landmarkVC.type = @"Landmark";
        landmarkVC.location = self.locationManager.location;
        landmarkVC.pathId = self.path.objectId;
        landmarkVC.delegate = self;

    }
    if ([segue.identifier isEqualToString:@"NewPathToDone"]) {
        EndPathViewController *endPathVC = (EndPathViewController *) segue.destinationViewController;

        endPathVC.delegate = self;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.initialZoom) {
        self.initialZoom = TRUE;
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
    if ([self.followSwitch isOn]) {
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
    [self.pathLine addCoordinate: locations.lastObject.coordinate];
    [self.pathway addCoordinate: locations.lastObject];
    self.pathpolyline = nil;
    self.pathpolyline = [GMSPolyline polylineWithPath: self.pathLine];
    self.pathpolyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
    self.pathpolyline.strokeWidth = 8.0;
    self.pathpolyline.map = self.gMapView;
}

- (void)addLandmarkViewController:(id)landmarkVC didAddLandmark:(Landmark *) landmark {
    
    if ([landmark.type isEqualToString: @"Landmark"]) {
        self.path.landmarkCount = @(self.path.landmarkCount.intValue + 1);
    }
    if ([landmark.type isEqualToString: @"Hazard"]) {
        self.path.hazardCount = @(self.path.hazardCount.intValue + 1);
    }
    
    [self.landmarks addObject: landmark];
    [self.landmarkMarkers addObject: [landmark addToMap: self.gMapView landmarkImage:self.landmarkImage hazardImage: self.hazardImage]];
    
}

- (NSNumber *) numberOfHazards {
    int count = 0;
    for (Landmark *landmark in self.landmarks) {
        if ([landmark.type isEqualToString: @"Hazard"]) {
            count++;
        }
    }
    return @(count);
}

- (NSNumber *) numberOfLandmarks {
    int count = 0;
    for (Landmark *landmark in self.landmarks) {
        if ([landmark.type isEqualToString: @"Landmark"]) {
            count++;
        }
    }
    return @(count);
}

- (nonnull NSDate *)startedAt {
    return self.path.startedAt;
}

- (NSNumber *) distanceTravelled {
    return self.pathway.distance;
}

- (void) endPathViewController: (EndPathViewController *) endPathVC endPathWithName: (NSString *) pathName timeElapsed: (NSNumber *) timeElapsed completion:( void (^)(void))completion{
    self.path.authorId = [PFUser currentUser].objectId;
    self.path.distance = self.pathway.distance;
    self.path.startPoint = self.pathway.path.firstObject;
    self.path.timeElapsed = timeElapsed;
    self.path.name = pathName;
    NSNumber *totalPaths = [PFUser currentUser][@"totalPaths"];
    [PFUser currentUser][@"totalPaths"] = @(totalPaths.intValue + 1);
    __block int calls = 0;
    [self.path postPath: self.pathway completion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [Landmark postLandmarks: self.landmarks pathId: self.path.objectId completion:^(BOOL succeeded, NSError * _Nullable error) {
                 if (error != nil) {
                     NSLog(@"%@", error.localizedDescription);
                 } else {
                     if (calls < 2) {
                         calls ++;
                     } else {
                         completion();
                     }
                 }
            }];
            if (calls < 2) {
                calls ++;
            } else {
                completion();
            }
        }
    }];
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            if (calls < 2) {
                calls ++;
                NSLog(@"user upload done");
            } else {
                completion();
            }
        }
    }];
    
    
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    for (int i = 0; i < self.landmarkMarkers.count; i++) {
        if (marker == self.landmarkMarkers[i]) {
            LandmarkDetailsViewController *dtvc = [LandmarkDetailsViewController detailViewAttachedToParentView: self];
            dtvc.loadImagesLocally = TRUE;
            [dtvc setLandmarkDetail: self.landmarks[i]];
        }
    }
}

- (void) didPressAddHazard: (id) sender {
    [self performSegueWithIdentifier: @"NewPathToHazard" sender: self.bottomView.addHazardButton];
}

- (void) didPressAddLandmark: (id) sender {
    [self performSegueWithIdentifier: @"NewPathToLandmark" sender: self.bottomView.addLandmarkButton];
}

- (void) didPressEndPath: (id) sender {
    [self performSegueWithIdentifier: @"NewPathToDone" sender: self.bottomView.endPathButton];
}
- (IBAction)didPressNewPath:(id)sender {
    [self startPath];
}

// Animation Transitions

- (void) setUpBottomView {
    self.bottomView = [[NewPathBottomView alloc] init];
    [self.bottomView.addHazardButton addTarget: self action:@selector(didPressAddHazard:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.addLandmarkButton addTarget: self action:@selector(didPressAddLandmark:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.endPathButton addTarget: self action:@selector(didPressEndPath:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview: self.bottomView];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    NSLayoutConstraint *leftConstraint = [self.bottomView.leftAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leftAnchor];
    [leftConstraint setActive: YES];
    
    NSLayoutConstraint *rightConstraint = [self.bottomView.rightAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.rightAnchor];
    [rightConstraint setActive: YES];
    
    NSLayoutConstraint *bottomConstraint = [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    [bottomConstraint setActive: YES];

    self.heightConstraint = [self.bottomView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.0];
    [self.heightConstraint setActive: YES];
    self.maximizedHeightConstraint = [self.bottomView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier: 0.2];
}

- (void) showBottomView {
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        self.tabBarController.tabBar.frame = CGRectMake(tabBarFrame.origin.x, tabBarFrame.origin.y + tabBarFrame.size.height, tabBarFrame.size.width, tabBarFrame.size.height);
        [self.heightConstraint setActive: NO];
        [self.maximizedHeightConstraint setActive: YES];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            CGRect tabBarFrame = self.tabBarController.tabBar.frame;
            self.tabBarController.tabBar.hidden = true;
            self.tabBarController.tabBar.frame = CGRectMake(tabBarFrame.origin.x, tabBarFrame.origin.y - tabBarFrame.size.height, tabBarFrame.size.width, tabBarFrame.size.height);
        }
    }];
}

- (void) hideBottomView {
    [UIView animateWithDuration:1.0 animations:^{
        CGRect tabBarFrame = self.tabBarController.tabBar.frame;
        self.tabBarController.tabBar.frame = CGRectMake(tabBarFrame.origin.x, tabBarFrame.origin.y - tabBarFrame.size.height, tabBarFrame.size.width, tabBarFrame.size.height);
        [self.heightConstraint setActive: YES];
        [self.maximizedHeightConstraint setActive: NO];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.tabBarController.tabBar.hidden = false;
        }
    }];
}

- (void) showFollowView {
    self.followView.hidden = NO;
}

- (void) hideFollowView {
    self.followView.hidden = YES;
}

- (void) showAddPathButton {
    self.addPathButton.hidden = NO;
}

- (void) hideAddPathButton {
    self.addPathButton.hidden = YES;
}

- (void) startPath {
    [self.locationManager startUpdatingLocation];
    [self showBottomView];
    [self hideAddPathButton];
    [self showFollowView];
}

@end
