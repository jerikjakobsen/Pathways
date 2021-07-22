//
//  EndPathViewController.h
//  Pathways
//
//  Created by johnjakobsen on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Path.h"
#import "Pathway.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EndPathViewControllerDelegate

- (NSNumber *) numberOfHazards;
- (NSNumber *) numberOfLandmarks;
- (NSNumber *) distanceTravelled;
- (NSDate *) startedAt;
- (void) endPathViewController: (id) endPathVC endPathWithName: (NSString *) pathName timeElapsed: (NSNumber *) timeElapsed;

@end

@interface EndPathViewController : UIViewController

@property (weak, nonatomic) id<EndPathViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
