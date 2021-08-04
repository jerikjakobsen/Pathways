//
//  GMSMarkerWithID.h
//  Pathways
//
//  Created by johnjakobsen on 8/3/21.
//

#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMSMarkerWithID : GMSMarker

@property (strong, nonatomic) NSString *markerID;
@property (nonatomic) bool isPath;

+ (instancetype) markerWithPosition:(CLLocationCoordinate2D)position markerID: (NSString *) markerID isPath: (bool) isPath;

@end

NS_ASSUME_NONNULL_END
