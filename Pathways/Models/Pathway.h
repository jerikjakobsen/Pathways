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
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *pathwayId;

- (instancetype) initFromLocal;

- (void) addCoordinate: (CLLocation *) coordinate;

- (void) postPathway: (PFBooleanResultBlock _Nullable) completion;

// The orientation of the path from the start point to the second point
- (double) startBearing;

+ (void) GET: (NSString *) pathId completion: (void (^)(Pathway *, NSError *)) completion;

@end

NS_ASSUME_NONNULL_END
