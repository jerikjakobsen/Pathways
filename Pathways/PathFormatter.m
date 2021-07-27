//
//  PathFormatter.m
//  Pathways
//
//  Created by johnjakobsen on 7/26/21.
//

#import "PathFormatter.h"
#import "Pathway.h"
#import <Parse/PFGeoPoint.h>

@implementation PathFormatter

+ (void) removeOutliars: (Pathway *) pathway {
    NSArray *oldPathway = pathway.path;
    unsigned int i = 0;
    NSMutableArray *removeIndices = [[NSMutableArray alloc] init];
    for (PFGeoPoint *point in oldPathway) {
        if (i > 1 && i < oldPathway.count - 1) {
            PFGeoPoint *previousPoint = oldPathway[i-1];
            PFGeoPoint *nextPoint = oldPathway[i+1];
            float distanceFromP1ToP2 = (previousPoint.latitude - point.latitude) * (previousPoint.latitude - point.latitude) + (previousPoint.longitude - point.longitude) *(previousPoint.longitude - point.longitude);
            
            float distanceFromP2toP3 = (point.latitude - nextPoint.latitude) * (point.latitude - nextPoint.latitude) + (point.longitude - nextPoint.longitude) * (point.longitude - nextPoint.longitude);
            
            float distanceFromP1toP3 = (previousPoint.latitude - nextPoint.latitude) * (previousPoint.latitude - nextPoint.latitude) + (previousPoint.longitude - nextPoint.longitude) * (previousPoint.longitude - nextPoint.longitude);
            if (distanceFromP1toP3 < distanceFromP2toP3 || distanceFromP1toP3 < distanceFromP1ToP2) {
                [removeIndices addObject: @(i)];
            }
        }
        
        i++;
    }
}

@end
