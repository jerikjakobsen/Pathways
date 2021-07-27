//
//  LandmarkDetailHeaderView.h
//  Pathways
//
//  Created by johnjakobsen on 7/27/21.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface LandmarkDetailHeaderView : UICollectionReusableView

@property (strong, nonatomic) UIStackView *titleStackView;
@property (strong, nonatomic) UIStackView *contentStackView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *landmarkTypeImageView;

- (void) setDetails: (Landmark *) landmark;

@end

NS_ASSUME_NONNULL_END
