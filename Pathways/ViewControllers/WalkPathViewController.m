//
//  WalkPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/20/21.
//

#import "WalkPathViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>


@interface WalkPathViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end

@implementation WalkPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.path drawPathToMapWithLandmarks:self.landmarks pathway:self.pathway map:self.gMapView];
    self.gMapView.camera = [GMSCameraPosition cameraWithLatitude:self.path.startPoint.latitude longitude:self.path.startPoint.longitude zoom:20 bearing: [self.pathway startBearing] viewingAngle:0.0];
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 6;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([self.followSwitch isOn]) {
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
}

@end
