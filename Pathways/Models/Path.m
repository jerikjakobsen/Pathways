//
//  Path.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Path.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@implementation Path
@dynamic name;
@dynamic timeElapsed;
@dynamic createdAt;
@dynamic startPoint;
@dynamic endPoint;
@dynamic distance;
@dynamic pathId;
@dynamic authorId;


- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            createdAt: (NSDate *) createdAt
            startPoint: (PFGeoPoint *) startPoint
            endPoint: (PFGeoPoint *) endPoint
            distance: (NSNumber *) distance
             authorId: (NSString *) authorId {
    if (self = [super init]) {
        self.name = name;
        self.timeElapsed = timeElapsed;
        self.createdAt = createdAt;
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.distance = distance;
        self.authorId = authorId;
    }
    return self;
}

- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            createdAt: (NSDate *) createdAt
            authorId: (NSString *) authorId
            pathway: (Pathway *) pathway {
                if (self = [super init]) {
                    self.name = name;
                    self.timeElapsed = timeElapsed;
                    self.createdAt = createdAt;
                    self.authorId = authorId;
                    if (pathway != nil) {
                        CLLocation *firstp = pathway.path.firstObject;
                        CLLocation *lastp = pathway.path.lastObject;
                        self.startPoint = [PFGeoPoint geoPointWithLocation: firstp];
                        self.endPoint = [PFGeoPoint geoPointWithLocation: lastp];
                        self.distance = @(pathway.distance);
                    }
                }
                return self;
}
- (void) postPath: (Pathway *) pathway completion: (PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [pathway saveInBackgroundWithBlock: completion];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

+ (nonnull NSString *)parseClassName {
    return @"Path";
}

@end
