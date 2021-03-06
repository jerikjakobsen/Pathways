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
#import "PathDetailsViewController.h"
#import "NewPathBottomView.h"
#import "Pathway.h"
#import "Path.h"
#import "Landmark.h"
#import "GMSMarkerWithID.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSPolyline.h>
#import <CoreLocation/CLLocationManager.h>

@interface NewPathViewController () <CLLocationManagerDelegate, AddLandMarkViewControllerDelegate, EndPathViewControllerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIButton *addPathButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshMapButton;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Pathway *pathway;
@property (strong, nonatomic) Path *path;
@property (strong, nonatomic) NSMutableArray *landmarks;
@property (strong, nonatomic) NSMutableArray *landmarkMarkers;
@property (strong, nonatomic) GMSMutablePath *pathLine;
@property (strong, nonatomic) GMSPolyline *pathpolyline;
@property (strong, nonatomic) UIImage *hazardImage;
@property (strong, nonatomic) UIImage *landmarkImage;
@property (strong, nonatomic) NewPathBottomView *bottomView;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *maximizedHeightConstraint;
@property (strong, nonatomic) NSArray *pathMarkers;
@property (strong, nonatomic) NSMutableDictionary *pathIDtoPaths;
@property (nonatomic) UIEdgeInsets mapInsetConstant;
@property (nonatomic) BOOL firstLoad;
@property (nonatomic) BOOL initialZoom;

@end

@implementation NewPathViewController

- (id) init {
    if (self = [super init]) {
        self.landmarkImage = [UIImage imageNamed:@"colosseum"];
        self.hazardImage = [UIImage imageNamed:@"wildfire"];
        self.firstLoad = TRUE;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *) coder {
    if (self = [super initWithCoder: coder]) {
        self.landmarkImage = [UIImage imageNamed:@"colosseum"];
        self.hazardImage = [UIImage imageNamed:@"wildfire"];
        self.firstLoad = TRUE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initialZoom = FALSE;
    if (self.firstLoad) {
        self.navigationController.navigationBarHidden = TRUE;
        [self hideFollowView];
        [self setUpBottomView];
        [self setUpGMSMapView];
        [self setUpLocationManager];
        self.firstLoad = FALSE;
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
    if ([segue.identifier isEqualToString: @"HomeToPathDetails"]) {
        PathDetailsViewController *PDVC = (PathDetailsViewController *) segue.destinationViewController;
        GMSMarkerWithID *marker = (GMSMarkerWithID *) sender;
        PDVC.path = [self.pathIDtoPaths objectForKey: [marker markerID]];
    }
}

- (void) setUpGMSMapView {
    self.pathLine = [GMSMutablePath path];
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    [self.gMapView animateToZoom: 20];
    self.gMapView.delegate = self;
    float insetValTabBar = (self.view.frame.size.height * 0.15 - self.tabBarController.tabBar.frame.size.height);
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0.0, 0.0, insetValTabBar, 0.0);
    self.mapInsetConstant = mapInsets;
}

- (void) setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 6.0;
    self.locationManager.allowsBackgroundLocationUpdates = TRUE;
    self.locationManager.pausesLocationUpdatesAutomatically = FALSE;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.initialZoom) {
        self.initialZoom = TRUE;
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
        [self.locationManager stopUpdatingLocation];
        [self showRefreshButton];
    } else {
        [self.pathLine addCoordinate: locations.lastObject.coordinate];
        [self.pathway addCoordinate: locations.lastObject];
        self.pathpolyline = nil;
        self.pathpolyline = [GMSPolyline polylineWithPath: self.pathLine];
        self.pathpolyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
        self.pathpolyline.strokeWidth = 8.0;
        self.pathpolyline.map = self.gMapView;
    }
    
    if ([self.followSwitch isOn]) {
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
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

- (NSNumber *) endPathViewControllerNumberOfHazards {
    int count = 0;
    for (Landmark *landmark in self.landmarks) {
        if ([landmark.type isEqualToString: @"Hazard"]) {
            count++;
        }
    }
    return @(count);
}

- (NSNumber *) endPathViewControllerNumberOfLandmarks {
    int count = 0;
    for (Landmark *landmark in self.landmarks) {
        if ([landmark.type isEqualToString: @"Landmark"]) {
            count++;
        }
    }
    return @(count);
}

- (nonnull NSDate *)endPathViewControllerStartedAt {
    return self.path.startedAt;
}

- (NSNumber *) endPathViewControllerDistanceTravelled {
    return self.pathway.distance;
}

- (void) endPathViewController: (EndPathViewController *) endPathVC endPathWithName: (NSString *) pathName timeElapsed: (NSNumber *) timeElapsed{
    self.path.authorId = [PFUser currentUser].objectId;
    self.path.distance = self.pathway.distance;
    self.path.startPoint = self.pathway.path.firstObject;
    self.path.timeElapsed = timeElapsed;
    self.path.name = pathName;
    NSNumber *totalPaths = [PFUser currentUser][@"totalPaths"];
    [PFUser currentUser][@"totalPaths"] = @(totalPaths.intValue + 1);
    [self.path postPath: self.pathway completion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [Landmark postLandmarks: self.landmarks pathId: self.path.objectId completion:^(BOOL succeeded, NSError * _Nullable error) {
                    [self.landmarkMarkers removeAllObjects];
                    [self.landmarks removeAllObjects];
                    self.path = nil;
                    self.pathway = nil;
                     if (error != nil) {
                         NSLog(@"Error: %@", error.localizedDescription);
                     }
            }];
        }
    }];
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [self endPath];
    
}

- (void) endPathViewControllerDidCancelPath {
    [self endPath];
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    for (int i = 0; i < self.landmarkMarkers.count; i++) {
        if (marker == self.landmarkMarkers[i]) {
            LandmarkDetailsViewController *dtvc = [LandmarkDetailsViewController detailViewAttachedToParentView: self safeArea: NO loadImagesLocally: YES];
            [dtvc setLandmarkDetail: self.landmarks[i]];
            return;
        }
    }
    GMSMarkerWithID *markerWithID = (GMSMarkerWithID *) marker;
    [self performSegueWithIdentifier:@"HomeToPathDetails" sender: markerWithID];
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
- (IBAction)didPressRefreshMap:(id)sender {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.gMapView.camera.target.latitude longitude:self.gMapView.camera.target.longitude];
    [Path drawPathMarksToMapInBackground: location mapView:self.gMapView completion:^(bool succeeded, NSError *  error, NSArray *pathMarkers, NSMutableDictionary *pathIDtoPath) {
        if (error != nil) {
            NSLog(@"Error: %@", error);
        } else {
            for (GMSMarker *marker in self.pathMarkers) {
                marker.map = nil;
            }
            self.pathMarkers = nil;
            self.pathMarkers = pathMarkers;
            self.pathIDtoPaths = pathIDtoPath;
        }
    }];
}

// Animation Transitions

- (void) setUpBottomView {
    self.bottomView = [[NewPathBottomView alloc] init];
    [self.bottomView.addHazardButton addTarget: self action:@selector(didPressAddHazard:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.addLandmarkButton addTarget: self action:@selector(didPressAddLandmark:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.endPathButton addTarget: self action:@selector(didPressEndPath:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self.view addSubview: self.bottomView];
    
    NSLayoutConstraint *leftConstraint = [self.bottomView.leftAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leftAnchor];
    [leftConstraint setActive: YES];
    
    NSLayoutConstraint *rightConstraint = [self.bottomView.rightAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.rightAnchor];
    [rightConstraint setActive: YES];
    
    NSLayoutConstraint *bottomConstraint = [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    [bottomConstraint setActive: YES];
    
    self.heightConstraint = [self.bottomView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.0];
    [self.heightConstraint setActive: YES];
    self.maximizedHeightConstraint = [self.bottomView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier: 0.15];
}

- (void) showBottomView {
    self.bottomView.hidden = FALSE;
    [self.heightConstraint setActive: NO];
    [self.maximizedHeightConstraint setActive: YES];
    self.tabBarController.tabBar.hidden = true;
    [UIView animateWithDuration:1.0 animations:^{
        self.gMapView.padding = self.mapInsetConstant;
        [self.view layoutIfNeeded];
    }];
}

- (void) hideBottomView: (bool) animated {
    [self.maximizedHeightConstraint setActive: NO];
    [self.heightConstraint setActive: YES];
    self.tabBarController.tabBar.hidden = false;
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^{
            self.gMapView.padding = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                self.bottomView.hidden = TRUE;
            }
        }];
    } else {
        self.gMapView.padding = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        [self.view layoutIfNeeded];
        self.bottomView.hidden = TRUE;
    }
}

- (void) showFollowView {
    self.followView.hidden = NO;
}

- (void) hideFollowView {
    self.followView.hidden = YES;
    [self.followSwitch setOn: NO];
    [self didSwitchFollow: self.followSwitch];
}

- (void) showAddPathButton {
    self.addPathButton.hidden = NO;
}

- (void) hideAddPathButton {
    self.addPathButton.hidden = YES;
}

- (void) hideRefreshButton {
    self.refreshMapButton.hidden = YES;
    for (GMSMarker *marker in self.pathMarkers) {
        marker.map = nil;
    }
}

- (void) showRefreshButton {
    self.refreshMapButton.hidden = NO;
    for (GMSMarker *marker in self.pathMarkers) {
        marker.map = self.gMapView;
    }
}

- (void) startPath {
    if (self.landmarks == nil) {
        self.landmarks = [[NSMutableArray alloc] init];
    } else {
        [self.landmarks removeAllObjects];
    }
    
    if (self.landmarkMarkers == nil) {
        self.landmarkMarkers = [[NSMutableArray alloc] init];
    } else {
        [self.landmarkMarkers removeAllObjects];
    }
    
    self.path = nil;
    self.pathway = nil;
    self.path = [[Path alloc] initFromLocal];
    self.pathway = [[Pathway alloc] initFromLocal];
    [self.pathLine removeAllCoordinates];
    [self.gMapView clear];
    [self.locationManager startUpdatingLocation];
    [self showBottomView];
    [self hideAddPathButton];
    [self showFollowView];
    [self hideRefreshButton];
}

- (void) endPath {
    [self.pathLine removeAllCoordinates];
    [self.gMapView clear];
    [self.locationManager stopUpdatingLocation];
    [self hideBottomView: NO];
    [self showAddPathButton];
    [self hideFollowView];
    [self showRefreshButton];
}

@end
