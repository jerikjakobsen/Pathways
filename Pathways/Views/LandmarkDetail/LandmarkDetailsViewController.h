//
//  LandmarkDetailsViewController.h
//  Pathways
//
//  Created by johnjakobsen on 7/21/21.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface LandmarkDetailsViewController : UIViewController

@property (strong, nonatomic) Landmark *landmark;

- (void) configureConstraintsOnParentView: (UIView *) parentView;

- (void) addToParentView: (UIViewController *) viewController;

- (void) setLandmarkDetail: (Landmark *) landmark;

+ (LandmarkDetailsViewController *) detailViewAttachedToParentView: (UIViewController *) viewController;

@end

NS_ASSUME_NONNULL_END