//
//  LandmarkPhotoCell.h
//  Pathways
//
//  Created by johnjakobsen on 7/21/21.
//

#import <UIKit/UIKit.h>
#import <Parse/PFImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LandmarkPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;

@end

NS_ASSUME_NONNULL_END
