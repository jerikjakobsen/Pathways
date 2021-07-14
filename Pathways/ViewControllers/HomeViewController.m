//
//  HomeViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "HomeViewController.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *startPathButton;
@property BOOL didSetUserLocation;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gMapView.myLocationEnabled = YES;
    self.didSetUserLocation = FALSE;
    self.gMapView.settings.myLocationButton  = YES;
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@", locations);
    if (!self.didSetUserLocation) {
        GMSCameraPosition *camera = [GMSCameraPosition
                                     cameraWithLatitude: locations.lastObject.coordinate.latitude
                                     longitude: locations.lastObject.coordinate.longitude
                                     zoom:20.0];
        self.gMapView.camera = camera;
        [self.gMapView setCamera: camera];
        self.didSetUserLocation = TRUE;
        [self.locationManager stopUpdatingLocation];
    }
}

@end
