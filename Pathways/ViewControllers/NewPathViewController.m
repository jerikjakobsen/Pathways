//
//  NewPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "NewPathViewController.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSPolyline.h>
#import <CoreLocation/CoreLocation.h>
#import "Pathway.h"

@interface NewPathViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) Pathway *pathway;
@property GMSMutablePath *path;
@property (weak, nonatomic) IBOutlet UISwitch *followSwitch;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewToMapViewConstraint;

@end

@implementation NewPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomView.layer.cornerRadius = self.bottomView.frame.size.width /20;
    self.bottomViewToMapViewConstraint.constant = -5 - self.bottomView.frame.size.width /20;
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(0.0, 0.0, 5 + self.bottomView.frame.size.width /20, 0.0);
    self.gMapView.padding = mapInsets;
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = TRUE;
    
    self.path = [GMSMutablePath path];
    self.pathway = [Pathway new];
    
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
        NSLog(@"Switched");
        [self.gMapView animateToLocation: self.gMapView.myLocation.coordinate];
        [self.gMapView animateToZoom: 20];
        self.gMapView.settings.scrollGestures = FALSE;
    } else {
        self.gMapView.settings.scrollGestures = TRUE;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if ([self.followSwitch isOn]) {
//        GMSCameraPosition *camera = [GMSCameraPosition
//                                     cameraWithLatitude: locations.lastObject.coordinate.latitude
//                                     longitude: locations.lastObject.coordinate.longitude
//                                     zoom: self.gMapView.camera.zoom];
//        self.gMapView.camera = camera;
        [self.gMapView animateToLocation:locations.lastObject.coordinate];
    }
    
    [self.path addCoordinate: locations.lastObject.coordinate];
    [self.gMapView clear];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath: self.path];
    polyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
    polyline.strokeWidth = 10.0;
    polyline.map = self.gMapView;
}

@end
