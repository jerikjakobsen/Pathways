//
//  WalkPathViewController.h
//  Pathways
//
//  Created by johnjakobsen on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Pathway.h"
#import "Path.h"
#import "Landmark.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalkPathViewController : UIViewController

@property (nonatomic, strong) Path *path;
@property (strong, nonatomic) Pathway *pathway;
@property (strong, nonatomic) NSArray *landmarks;

@end

NS_ASSUME_NONNULL_END
