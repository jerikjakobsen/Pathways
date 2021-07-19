//
//  PathDetailsViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/18/21.
//

#import "PathDetailsViewController.h"
#import "LandmarkCell.h"
#import "Landmark.h"
#import "Path.h"
#import "Pathway.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface PathDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceWalkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;
@property (weak, nonatomic) IBOutlet UITableView *landmarkTableView;
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (strong, nonatomic) NSArray *landmarks;
@property (strong, nonatomic) UIImage *hazardImage;
@property (strong, nonatomic) UIImage *landmarkImage;

@end

@implementation PathDetailsViewController

//TODO: Configure map view

- (void)viewDidLoad {
    [super viewDidLoad];
    self.landmarkImage = [UIImage imageNamed:@"colosseum"];
    self.hazardImage = [UIImage imageNamed:@"wildfire"];
    self.titleLabel.text = self.path.name;
    self.distanceWalkedLabel.text = [NSString stringWithFormat: @"Walked %.2f meters", self.path.distance.floatValue];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat: @"MMMM d, yyyy"];
    self.dateLabel.text = [format stringFromDate: self.path.startedAt];
    self.timeTakenLabel.text = [self timeTakenString: self.path.startedAt];
    [self setupTableView];
    [Landmark getLandmarks: self.path.objectId completion:^(NSArray * _Nonnull landmarks, NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.landmarks = landmarks;
            [self.landmarkTableView reloadData];
        }
    }];
    
    [Pathway GET: self.path.objectId completion:^(Pathway * _Nonnull pathway, NSError * _Nonnull error) {
        GMSMutablePath *pathLine = [GMSMutablePath path];
        if (error == nil) {
            for (PFGeoPoint *point in pathway.path) {
                [pathLine addLatitude:point.latitude longitude:point.longitude];
            }
            GMSPolyline *pathpolyline = [GMSPolyline polylineWithPath: pathLine];
            pathpolyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
            pathpolyline.strokeWidth = 7.0;
            pathpolyline.map = self.gMapView;
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathLine];
            UIEdgeInsets mapInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            GMSCameraPosition* camera = [self.gMapView cameraForBounds:bounds insets:mapInsets];
            [self.gMapView animateToCameraPosition: camera];
        } else {
            NSLog(@"Error getting Pathway:%@", error.localizedDescription);
        }
    }];
    [Landmark getLandmarks:self.path.objectId completion:^(NSArray * _Nonnull landmarks, NSError * _Nonnull error) {
        if (error == nil) {
            [Landmark addLandmarksToMap:landmarks mapView:self.gMapView landmarkImage:self.landmarkImage hazardImage:self.hazardImage];
        } else {
            NSLog(@"Error getting landmarks: %@", error.localizedDescription);
        }
    }];
    [self.gMapView animateToZoom: 20];
}

- (void) setupTableView {
    self.landmarkTableView.delegate = self;
    self.landmarkTableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"LandmarkCell" bundle: nil];
    [self.landmarkTableView registerNib:nib forCellReuseIdentifier:@"LandmarkCell"];
}



- (NSString *) timeTakenString: (NSDate *) startedAt {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *conversion = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: startedAt toDate: [NSDate dateWithTimeInterval: self.path.timeElapsed.doubleValue sinceDate:self.path.startedAt] options:0];
    NSString *hourString, *minuteString, *secondString;
    if ([conversion hour] > 0) {
        hourString = [NSString stringWithFormat: @"%ld hrs ", (long)[conversion hour] ];
    } else {
        hourString = @"";
    }
    
    if ([conversion minute] > 0) {
        minuteString = [NSString stringWithFormat: @"%ld mins ", (long)[conversion minute] ];
    } else {
        minuteString = @"";
    }
    
    if ([conversion second]) {
        secondString = [NSString stringWithFormat: @"%ld seconds", (long)[conversion second] ];
    } else {
        secondString = @"";
    }
    NSString *timeTaken = [NSString stringWithFormat:@"%@%@%@", hourString, minuteString, secondString];
    if ([timeTaken isEqualToString: @""]) {
        timeTaken = @"0 Seconds";
    }
    return timeTaken;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandmarkCell *cell = [self.landmarkTableView dequeueReusableCellWithIdentifier: @"LandmarkCell"];
    Landmark *landmark = self.landmarks[indexPath.row];
    [cell configureCell: landmark];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.landmarks.count;
}

@end
