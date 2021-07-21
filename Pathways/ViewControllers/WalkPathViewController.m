//
//  WalkPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/20/21.
//

#import "WalkPathViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Pathway.h"

@interface WalkPathViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;

@end

@implementation WalkPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSMutablePath *pathLine = [GMSMutablePath path];
    
    [Pathway GET: self.path.objectId completion:^(Pathway * _Nonnull pathway, NSError * _Nonnull error) {
        if (error == nil) {
            GMSMutablePath *pathLine = [GMSMutablePath path];

        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    self.gMapView.myLocationEnabled = YES;
    self.gMapView.settings.myLocationButton  = YES;
    [self.gMapView animateToZoom: 20];
    
}



@end
