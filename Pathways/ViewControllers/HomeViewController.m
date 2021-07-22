//
//  HomeViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "HomeViewController.h"
#import "GoogleMapsStaticAPI.h"
#import <GoogleMaps/GMSMapView.h>
#import <GoogleMaps/GMSCameraPosition.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (weak, nonatomic) IBOutlet UIButton *startPathButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL didSetUserLocation;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = FALSE;
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

- (IBAction)unwindToHomeViewController:(UIStoryboardSegue *)unwindSegue {
    // This is a tag for the unwind segue to work
    // Leave this function in as a signal for any view controller that wants to use the unwind segue
    // Use the "UnwindToHome" segue identifier to return back to this view controller
    
    self.tabBarController.tabBar.hidden = false;
}

@end
