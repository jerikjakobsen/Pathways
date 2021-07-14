//
//  Pathway.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Pathway.h"

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
        self.distance = 0.0;
    }
    else {
        self.distance += [coordinate distanceFromLocation: self.path.lastObject];
    }
    if (self.path.count > 1 && [coordinate distanceFromLocation: self.path.lastObject] > 6.0) {
        [self.path addObject: coordinate];
    }
    
}

- (void) postPathway: (PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:completion];
}

+ (nonnull NSString *)parseClassName {
    return @"Pathway";
}

@end
