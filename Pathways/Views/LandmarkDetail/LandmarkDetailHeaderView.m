//
//  LandmarkDetailHeaderView.m
//  Pathways
//
//  Created by johnjakobsen on 7/27/21.
//

#import "LandmarkDetailHeaderView.h"

@implementation LandmarkDetailHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder: coder]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype) init {
    if (self = [super init]) {
        [self initSubviews];

    }
    return self;
}

- (instancetype) initWithTitle: (NSString *) title description: (NSString *) description type: (NSString *) type {
    if (self = [self init]) {
        [self initSubviews];
        self.titleLabel.text = title;
        self.descriptionLabel.text = description;
        if ([type isEqualToString:@"Hazard"]) {
            self.landmarkTypeImageView.image = [UIImage imageNamed:@"wildfire"];
        } else {
            self.landmarkTypeImageView.image = [UIImage imageNamed:@"colosseum"];
        }
        [self.titleStackView addArrangedSubview: self.titleLabel];
        [self.titleStackView addArrangedSubview: self.landmarkTypeImageView];
        [self.contentStackView addSubview: self.titleStackView];
        [self.contentStackView addSubview: self.descriptionLabel];
        [self addSubview: self.contentStackView];
        self.contentStackView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

- (void)initSubviews {
    self.translatesAutoresizingMaskIntoConstraints = FALSE;
    self.contentStackView = [[UIStackView alloc] init];
    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = FALSE;
    
    self.titleStackView = [[UIStackView alloc] init];
    self.titleStackView.axis = UILayoutConstraintAxisHorizontal;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.descriptionLabel = [[UILabel alloc] init];
    self.landmarkTypeImageView = [[UIImageView alloc] init];
    self.landmarkTypeImageView.translatesAutoresizingMaskIntoConstraints = FALSE;
    self.landmarkTypeImageView.contentMode = UIViewContentModeScaleAspectFill;

    NSLayoutConstraint *widthConstraintForImageView = [self.landmarkTypeImageView.widthAnchor constraintEqualToConstant: 50];
    NSLayoutConstraint *heightConstraintForImageView = [self.landmarkTypeImageView.heightAnchor constraintEqualToConstant: 50];
    [widthConstraintForImageView setActive: YES];
    [heightConstraintForImageView setActive: YES];
    
    [self.titleStackView addArrangedSubview: self.titleLabel];
    [self.titleStackView addArrangedSubview: self.landmarkTypeImageView];
    [self.contentStackView addArrangedSubview: self.titleStackView];
    [self.contentStackView addArrangedSubview: self.descriptionLabel];
    [self addSubview: self.contentStackView];
    NSLayoutConstraint *topAnchor = [self.contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor];
    NSLayoutConstraint *leftAnchor = [self.contentStackView.leftAnchor constraintEqualToAnchor: self.leftAnchor];
    NSLayoutConstraint *bottomAnchor = [self.contentStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint *rightAnchor = [self.contentStackView.rightAnchor constraintEqualToAnchor: self.rightAnchor];
    [topAnchor setActive: YES];
    [leftAnchor setActive: YES];
    [bottomAnchor setActive: YES];
    [rightAnchor setActive: YES];
}


- (void) setDetails: (Landmark *) landmark {
    self.titleLabel.text = landmark.name;
    if (landmark.details.length == 0 || landmark.details == nil) {
        [self.contentStackView removeArrangedSubview: self.descriptionLabel];
    } else {
        self.descriptionLabel.text = landmark.details;
    }
    [self setType: landmark.type];
    [self sizeToFit];

}

- (void) setType: (NSString *) type {
    if ([type isEqualToString:@"Hazard"]) {
        self.landmarkTypeImageView.image = [UIImage imageNamed:@"wildfire"];
    } else {
        self.landmarkTypeImageView.image = [UIImage imageNamed:@"colosseum"];
    }
}



@end
