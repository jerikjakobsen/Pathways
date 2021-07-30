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
#import "WalkPathViewController.h"
#import "LandmarkDetailsViewController.h"

@interface PathDetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceWalkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;
@property (weak, nonatomic) IBOutlet UITableView *landmarkTableView;
@property (weak, nonatomic) IBOutlet GMSMapView *gMapView;
@property (strong, nonatomic) NSArray *landmarks;
@property (strong, nonatomic) Pathway *pathway;
@property (strong, nonatomic) UIImage *hazardImage;
@property (strong, nonatomic) UIImage *landmarkImage;

@end

@implementation PathDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUIInfo];
    [self setupTableView];
    [self setUpMapView];
}

- (void)setUpMapView {
    [self.path drawPathToMapWithLandmarksWithCompletion:^(NSError * error, NSArray * landmarks, Pathway * pathway) {
        if (error == nil) {
            self.landmarks = landmarks;
            [self.landmarkTableView reloadData];
            self.pathway = pathway;
            GMSMutablePath *pathLine = [GMSMutablePath path];
            for (PFGeoPoint *point in pathway.path) {
                [pathLine addLatitude:point.latitude longitude:point.longitude];
            }
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:pathLine];
            UIEdgeInsets mapInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
            GMSCameraPosition* camera = [self.gMapView cameraForBounds:bounds insets:mapInsets];
            [self.gMapView animateToCameraPosition: camera];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    } map:self.gMapView];
    [self.gMapView animateToZoom: 20];
}

- (void)setUpUIInfo {
    self.landmarkImage = [UIImage imageNamed:@"colosseum"];
    self.hazardImage = [UIImage imageNamed:@"wildfire"];
    self.titleLabel.text = self.path.name;
    self.distanceWalkedLabel.text = [NSString stringWithFormat: @"Walked %.2f meters", self.path.distance.floatValue];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat: @"MMMM d, yyyy"];
    self.dateLabel.text = [format stringFromDate: self.path.startedAt];
    self.timeTakenLabel.text = [self timeTakenString: self.path.startedAt];
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
        hourString = [NSString stringWithFormat: @"%ld hrs ", (long) [conversion hour] ];
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

- (IBAction)didTapWalkPath:(id)sender {
    [self performSegueWithIdentifier: @"PathDetailsToWalkPath" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"PathDetailsToWalkPath"]) {
        WalkPathViewController *WPVC = segue.destinationViewController;
        WPVC.landmarks = self.landmarks;
        WPVC.path = self.path;
        WPVC.pathway = self.pathway;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LandmarkDetailsViewController *detView = [LandmarkDetailsViewController detailViewAttachedToParentView:self safeArea:NO loadImagesLocally:NO];
    [detView setLandmarkDetail:self.landmarks[indexPath.row]];
}


@end
