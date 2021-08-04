//
//  GMSMarkerWithID.m
//  Pathways
//
//  Created by johnjakobsen on 8/3/21.
//

#import "GMSMarkerWithID.h"
#import <FCUUID/FCUUID.h>

@implementation GMSMarkerWithID

- (instancetype) init {
    if (self = [super init]) {
        [self setMarkerID: [FCUUID uuid]];
    }
    return self;
}

+ (instancetype) markerWithPosition:(CLLocationCoordinate2D)position {
    GMSMarkerWithID *marker = [super markerWithPosition: position];
    [marker setMarkerID: [FCUUID uuid]];
    return marker;
}

+ (instancetype) markerWithPosition:(CLLocationCoordinate2D)position markerID: (NSString *) markerID isPath:(bool)isPath {
    GMSMarkerWithID *marker = [super markerWithPosition: position];
    [marker setIsPath: isPath];
    [marker setMarkerID: markerID];
    return marker;
}


@end
