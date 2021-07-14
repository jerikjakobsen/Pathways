//
//  Pathway.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Parse/Parse.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pathway : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString* pathId;
@property (nonatomic, strong) NSMutableArray* path;
@property float distance;
@property (nonatomic, strong) NSString *pathwayId;

- (void) addCoordinate: (CLLocation *) coordinate;
- (void) postPathway: (PFBooleanResultBlock _Nullable) completion;
@end

NS_ASSUME_NONNULL_END
