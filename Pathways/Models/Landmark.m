//
//  Landmark.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Landmark.h"
#import <Parse/Parse.h>

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
    if (self.photos == nil) {
        self.photos = [[NSMutableArray alloc] init];
    }
    NSString *imageName = [NSString stringWithFormat: @"image%lu", (unsigned long)self.photos.count ];
    PFFileObject *file = [PFFileObject fileObjectWithName:imageName data: UIImagePNGRepresentation(photo)];
    [self.photos addObject: file];
}

- (void) postLandmark:(PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:completion];
}

+ (void) postLandmarks: (NSMutableArray *) landmarks
            pathId: (NSString *) pathId
            completion: (PFBooleanResultBlock _Nullable) completion {
    __block int count = 0;
    for (Landmark *landmark in landmarks) {
        landmark.pathId = pathId;
        NSLog(@"pooooo");
        [landmark postLandmark:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                count += 1;
                if (count == landmarks.count) {
                    NSLog(@"yayaya");
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
