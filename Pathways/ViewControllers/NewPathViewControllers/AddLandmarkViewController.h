//
//  AddLandmarkViewController.h
//  Pathways
//
//  Created by johnjakobsen on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AddLandMarkViewControllerDelegate

- (void) addLandmarkViewController: (id) landmarkVC didAddLandmark: (Landmark *) landmark;

@end

@interface AddLandmarkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *addLandmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *pathId;
@property (nonatomic, weak) id<AddLandMarkViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
