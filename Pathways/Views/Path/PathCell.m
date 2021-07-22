//
//  PathCell.m
//  Pathways
//
//  Created by johnjakobsen on 7/15/21.
//

#import "PathCell.h"

@implementation PathCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) configureCell:  (Path *) path username: (NSString *) username showUsername: (BOOL) showUsername
{
    self.path = path;
    self.titleLabel.text = path.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f meters", path.distance.floatValue];
    if (showUsername) {
        self.usernameLabel.text = username;
    } else {
        self.usernameLabel.hidden = TRUE;
    }
    self.landmarkCountLabel.text = [NSString stringWithFormat:@"%@", path.landmarkCount];
    self.hazardCountLabel.text = [NSString stringWithFormat: @"%@", path.hazardCount];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM d, yyyy"];
    self.dateLabel.text = [format stringFromDate: path.startedAt];
}

- (void) setPathOverview {
    //TODO: Get image from google of the overview of the path and set it to self.pathOverViewPFImage
}

@end
