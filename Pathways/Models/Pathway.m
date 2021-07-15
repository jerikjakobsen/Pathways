//
//  Pathway.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Pathway.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/PFGeoPoint.h>

@implementation Pathway
@dynamic path;
@dynamic pathId;
@dynamic distance;
@dynamic pathwayId;

- (void) addCoordinate: (CLLocation *) coordinate {
    if (self.path == nil) {
        self.path = [[NSMutableArray alloc] init];
    }
    
    if (self.path.count == 0) {
        self.distance = [NSNumber numberWithFloat: 0.0];
    }
    
    if (self.path.count > 1) {
        PFGeoPoint *point = self.path.lastObject;
        CLLocation *coord = [[CLLocation alloc] initWithLatitude: point.latitude longitude: point.longitude];
        float newDistance =  [coordinate distanceFromLocation: coord];
        self.distance = @(self.distance.floatValue + newDistance);
    }
    [self.path addObject: [PFGeoPoint geoPointWithLocation: coordinate]];
}

- (void) postPathway: (PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:completion];
}

+ (nonnull NSString *)parseClassName {
    return @"Pathway";
}

@end
