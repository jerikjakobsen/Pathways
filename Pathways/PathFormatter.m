//
//  PathFormatter.m
//  Pathways
//
//  Created by johnjakobsen on 7/26/21.
//

#import "PathFormatter.h"
#import <Parse/PFGeoPoint.h>

@implementation PathFormatter

+ (NSMutableArray *) removeOutliars: (NSMutableArray *) pathway {
    if (pathway.count < 3) return pathway;
    NSMutableArray *removedOutliarsArr = [[NSMutableArray alloc] init];
    [removedOutliarsArr addObject: pathway.firstObject];
    for (int i = 1; i < pathway.count - 1; i ++) {
        PFGeoPoint *point = pathway[i];
        PFGeoPoint *previousPoint = pathway[i-1];
        PFGeoPoint *nextPoint = pathway[i+1];
        
        float distanceFromP1ToP2 = pow((previousPoint.latitude - point.latitude), 2) + pow((previousPoint.longitude - point.longitude), 2);
        
        float distanceFromP2toP3 = pow((point.latitude - nextPoint.latitude), 2) + pow((point.longitude - nextPoint.longitude), 2);
        
        float distanceFromP1toP3 = pow((previousPoint.latitude - nextPoint.latitude), 2) + pow((previousPoint.longitude - nextPoint.longitude), 2);
        
        if (distanceFromP1toP3 > distanceFromP2toP3 && distanceFromP1toP3 > distanceFromP1ToP2) {
            [removedOutliarsArr addObject: point];
        } else i++;
    }
    [removedOutliarsArr addObject: pathway.lastObject];
    return removedOutliarsArr;
}

+ (NSMutableArray *) removeAllOutliars: (NSMutableArray *) pathway {
    unsigned long previousCount = pathway.count;
    pathway = [PathFormatter removeOutliars: pathway];
    if (previousCount - pathway.count > 0) {
        return [PathFormatter removeAllOutliars: pathway];
    }
    return pathway;
}

@end
