//
//  NewPathBottomView.h
//  Pathways
//
//  Created by johnjakobsen on 7/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPathBottomView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *addHazardButton;
@property (weak, nonatomic) IBOutlet UIButton *addLandmarkButton;
@property (weak, nonatomic) IBOutlet UIButton *endPathButton;

@end

NS_ASSUME_NONNULL_END
