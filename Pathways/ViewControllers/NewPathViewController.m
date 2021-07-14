//
//  NewPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "NewPathViewController.h"
#import <GoogleMaps/GMSMapView.h>
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followUserSwitch;

@end

@implementation NewPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.path = [GMSMutablePath path];
    self.pathway = [Pathway new];
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = TRUE;
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    self.locationManager = [[CLLocationManager alloc]  init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%@", locations);
    if (self.followUserSwitch.isActive) {
        self.gMapView.myLocationEnabled = TRUE;
//        GMSCameraPosition *camera = [GMSCameraPosition
//                                     cameraWithLatitude: locations.lastObject.coordinate.latitude
//                                     longitude: locations.lastObject.coordinate.longitude
//                                     zoom:20.0];
//        self.gMapView.camera = camera;
//        [self.gMapView setCamera: camera];
    } else self.gMapView.myLocationEnabled = FALSE;
    [self.path addCoordinate: locations.lastObject.coordinate];
    [self.gMapView clear];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath: self.path];
    polyline.geodesic = TRUE;
    polyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
    polyline.strokeWidth = 10.0;
    polyline.map = self.gMapView;
    
}
@end
