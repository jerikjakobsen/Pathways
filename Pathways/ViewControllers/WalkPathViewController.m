//
//  WalkPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/20/21.
//

#import "WalkPathViewController.h"
#import <GoogleMaps/GoogleMaps.h>


@interface WalkPathViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;

@end

@implementation WalkPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.path drawPathToMapWithLandmarks:self.landmarks pathway:self.pathway map:self.gMapView];
    self.gMapView.camera = [GMSCameraPosition cameraWithLatitude:self.path.startPoint.latitude longitude:self.path.startPoint.longitude zoom:20 bearing: [self.pathway startBearing] viewingAngle:0.0];
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    
}

@end
