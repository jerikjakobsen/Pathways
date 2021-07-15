//
//  Landmark.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Landmark.h"

@implementation Landmark

@dynamic name;
@dynamic details;
@dynamic type;
@dynamic createdAt;
@dynamic location;
@dynamic pathId;
@dynamic photos;
@dynamic landmarkId;

- (instancetype) init: (NSString *) name
            details: (NSString *) details
            type: (NSString *) type
            location: (PFGeoPoint *) location
            pathId: (NSString *) pathId {
    if (self = [super init]) {
        self.name = name;
        self.details = details;
        self.type = type;
        self.location = location;
        self.createdAt = [NSDate now];
        self.photos = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addPhoto: (UIImage *) photo {
    [self.photos addObject: photo];
}

- (void) postLandmark:(PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:completion];
}

+ (void) postLandmarks: (NSMutableArray *) landmarks completion: (PFBooleanResultBlock _Nullable) completion {
    __block int count = 0;
    for (Landmark *landmark in landmarks) {
        [landmark postLandmark:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                count += 1;
                if (count == landmarks.count) {
                    completion(TRUE, nil);
                }
            }
        }];
    }
}

+ (nonnull NSString *) parseClassName {
    return @"Landmark";
}

@end
