//
//  PathCell.h
//  Pathways
//
//  Created by johnjakobsen on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "Path.h"
#import <Parse/PFImageView.h>

NS_ASSUME_NONNULL_BEGIN

@interface PathCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *pathOverViewPFImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *landmarkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hazardCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) Path *path;

-(void) configureCell:  (Path *) path
             username: (NSString *) username;
@end

NS_ASSUME_NONNULL_END
