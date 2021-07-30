//
//  EndPathViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/14/21.
//

#import "EndPathViewController.h"


@interface EndPathViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceTravelledLabel;
@property (weak, nonatomic) IBOutlet UILabel *startedAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeTakenLabel;
@property (weak, nonatomic) IBOutlet UILabel *hazardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *landmarksLabel;
@property (weak, nonatomic) IBOutlet UITextField *pathNameTextField;

@end

@implementation EndPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLabels];
}

- (void)setLabels {
    float distanceTravelled = [self.delegate endPathViewControllerDistanceTravelled].floatValue;
    self.distanceTravelledLabel.text = [NSString stringWithFormat:@"%.1f meters",  distanceTravelled];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat: @"h:mm a"];
    self.startedAtLabel.text = [format stringFromDate: [self.delegate endPathViewControllerStartedAt]];
    self.timeTakenLabel.text = [self timeTakenString: [self.delegate endPathViewControllerStartedAt]];
    self.hazardsLabel.text = [NSString stringWithFormat: @"%@", [self.delegate endPathViewControllerNumberOfHazards] ];
    self.landmarksLabel.text = [NSString stringWithFormat: @"%@", [self.delegate endPathViewControllerNumberOfLandmarks] ];
}

- (NSString *) timeTakenString: (NSDate *) startedAt {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *conversion = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate: startedAt toDate: [NSDate now] options:0];
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

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEndPath:(id) sender {
    if (self.pathNameTextField.text.length < 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Path Name too Short" message:@"Name must be at least 4 characters long" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
    NSTimeInterval interval = [self.delegate endPathViewControllerStartedAt].timeIntervalSinceNow * -1;
        [self.delegate endPathViewController: self endPathWithName: self.pathNameTextField.text timeElapsed: @(interval)];
        [self dismissViewControllerAnimated: YES completion:nil];
    }
    
}

- (IBAction)cancelPath:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Cancelling the path will cause your path to be deleted forever" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deletePath = [UIAlertAction actionWithTitle:@"Delete Path" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate endPathViewControllerDidCancelPath];
        [self dismissViewControllerAnimated:YES completion: nil];
        
    }];
    UIAlertAction *cancelDeletePath = [UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleCancel handler: nil];
    [alert addAction: cancelDeletePath];
    [alert addAction: deletePath];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)didTapView:(id)sender {
    [self.view endEditing: YES];
}

@end

