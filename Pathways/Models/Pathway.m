//
//  Pathway.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Pathway.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/PFGeoPoint.h>
#import <Parse/PFQuery.h>

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

- (double) startBearing {
    PFGeoPoint *firstPoint = self.path.firstObject;
    PFGeoPoint *secondPoint = self.path[1];
    if (secondPoint == nil || firstPoint == nil) {
        return 0.0;
    }
    CLLocationDirection direction = atan2(secondPoint.longitude - firstPoint.longitude, secondPoint.latitude - firstPoint.latitude) * 180.0/ M_PI;
    return direction;
}


+ (void) GET: (NSString *) pathId completion: (void (^)(Pathway *, NSError *)) completion {
    PFQuery *query = [PFQuery queryWithClassName: @"Pathway"];
    [query whereKey: @"pathId" equalTo:pathId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            Pathway *pathway = objects.lastObject;
            completion(pathway, error);
    }];
}

+ (nonnull NSString *)parseClassName {
    return @"Pathway";
}

@end
