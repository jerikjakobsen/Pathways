//
//  Landmark.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Parse/Parse.h>
#import <CoreLocation/CLLocation.h>
#import <UIKit/UIImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface Landmark : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *pathId;
@property (nonatomic, strong) NSString *landmarkId;

- (instancetype) init: (NSString *) name
            details: (NSString *) details
            type: (NSString *) type
            location: (PFGeoPoint *) location
            pathId: (NSString *) pathId;

- (void) addPhoto: (UIImage *) photo;

- (void) postLandmark:(PFBooleanResultBlock _Nullable) completion;

+ (void) postLandmarks: (NSMutableArray *) landmarks
            pathId: (NSString *) pathId
            completion: (PFBooleanResultBlock _Nullable) completion;

+ (void) getLandmarks: (NSString *) pathId completion: (void (^)(NSArray *, NSError* )) completion;

@end

NS_ASSUME_NONNULL_END
