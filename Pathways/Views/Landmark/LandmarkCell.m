//
//  LandmarkCell.m
//  Pathways
//
//  Created by johnjakobsen on 7/18/21.
//

#import "LandmarkCell.h"

@implementation LandmarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell: (Landmark *) landmark {
    self.landmark = landmark;
    self.titleLabel.text = landmark.name;
    self.descriptionLabel.text = landmark.details;
    if ([landmark.type isEqualToString: @"Hazard"]) {
        self.typeImageView.image = [UIImage imageNamed: @"wildfire"];
    }
    if ([landmark.type isEqualToString: @"Landmark"]) {
        self.typeImageView.image = [UIImage imageNamed: @"colosseum"];
    }
    //TODO: Get first photo from landmark and use as detail image view,  replace with placeholder image if there is none
}
@end
