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

@interface PathDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceWalkedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;
@property (weak, nonatomic) IBOutlet UITableView *landmarkTableView;
@property (strong, nonatomic) NSArray *landmarks;

@end

@implementation PathDetailsViewController

//TODO: Configure map view

- (void)viewDidLoad {
    [super viewDidLoad];
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
