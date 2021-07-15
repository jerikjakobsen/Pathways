//
//  NewPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "NewPathViewController.h"
#import "AddLandmarkViewController.h"
#import "EndPathViewController.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSPolyline.h>
#import <CoreLocation/CoreLocation.h>
#import "Pathway.h"
#import "Path.h"
#import "Landmark.h"

@interface NewPathViewController () <CLLocationManagerDelegate, AddLandMarkViewControllerDelegate, EndPathViewControllerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewToMapViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addHazardButton;
@property (weak, nonatomic) IBOutlet UIButton *addLandmarkButton;
@property (weak, nonatomic) IBOutlet UIButton *endPathButton;

@property CLLocationManager *locationManager;
@property (strong, nonatomic) Pathway *pathway;
@property (strong, nonatomic) Path *path;
@property (strong, nonatomic) NSMutableArray *landmarks;
@property GMSMutablePath *pathLine;
@property (strong, nonatomic) NSMutableArray *bottomViewLayoutConstraints;

@end

@implementation NewPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.landmarks = [[NSMutableArray alloc] init];
    self.bottomView.layer.cornerRadius = self.bottomView.frame.size.width /20;
    self.bottomViewToMapViewConstraint.constant = -5 - self.bottomView.frame.size.width /20;
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0.0, 0.0, 5 + self.bottomView.frame.size.width /20, 0.0);
    self.gMapView.padding = mapInsets;
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = TRUE;
    
    self.pathLine = [GMSMutablePath path];
    self.pathway = [Pathway new];
    self.path = [Path new];
    self.path.startedAt = [NSDate now];
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    [self.gMapView animateToLocation: self.gMapView.myLocation.coordinate];
    [self.gMapView animateToZoom: 20];
    
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 6;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
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
    
    if ([self.followSwitch isOn]) {
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
    
    [self.pathLine addCoordinate: locations.lastObject.coordinate];
    [self.gMapView clear];
    [self.pathway addCoordinate: locations.lastObject];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath: self.pathLine];
    polyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
    polyline.strokeWidth = 10.0;
    polyline.map = self.gMapView;
}

- (void)addLandmark:(nonnull Landmark *)landmark {
    [self.landmarks addObject: landmark];
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

- (void) endPath:(NSString *)pathName timeElapsed: (NSNumber *) timeElapsed  {
    self.path.authorId = [PFUser currentUser].objectId;
    self.path.distance = self.pathway.distance;
    self.path.startPoint = self.pathway.path.firstObject;
    //self.path.endPoint = self.pathway.path.lastObject;
    self.path.timeElapsed = timeElapsed;
    self.path.name = pathName;
    [self.path postPath: self.pathway completion:^(BOOL succeeded, NSError * _Nullable error) {
        [Landmark postLandmarks: self.landmarks pathId: self.path.objectId completion:^(BOOL succeeded, NSError * _Nullable error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    
}

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue *)unwindSegue {}

@end
