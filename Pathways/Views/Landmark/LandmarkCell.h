//
//  LandmarkCell.h
//  Pathways
//
//  Created by johnjakobsen on 7/18/21.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"
NS_ASSUME_NONNULL_BEGIN

@interface LandmarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) Landmark* landmark;
- (void) configureCell: (Landmark *) landmark;

@end

NS_ASSUME_NONNULL_END
