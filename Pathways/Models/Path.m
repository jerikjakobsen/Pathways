//
//  Path.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Path.h"
#import "Landmark.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <GoogleMaps/GMSPolyline.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSCameraPosition.h>

@implementation Path

@dynamic name;
@dynamic timeElapsed;
@dynamic startPoint;
@dynamic distance;
@dynamic pathId;
@dynamic authorId;
@dynamic startedAt;
@dynamic hazardCount;
@dynamic landmarkCount;

- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            startPoint: (PFGeoPoint *) startPoint
            //endPoint: (PFGeoPoint *) endPoint
            distance: (NSNumber *) distance
             authorId: (NSString *) authorId {
    if (self = [super init]) {
        self.name = name;
        self.timeElapsed = timeElapsed;
        self.startPoint = startPoint;
        //self.endPoint = endPoint;
        self.distance = distance;
        self.authorId = authorId;
    }
    return self;
}

- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            authorId: (NSString *) authorId
            pathway: (Pathway *) pathway {
                if (self = [super init]) {
                    self.name = name;
                    self.timeElapsed = timeElapsed;
                    self.authorId = authorId;
                    if (pathway != nil) {
                        CLLocation *firstp = pathway.path.firstObject;
                        //CLLocation *lastp = pathway.path.lastObject;
                        self.startPoint = [PFGeoPoint geoPointWithLocation: firstp];
                        //self.endPoint = [PFGeoPoint geoPointWithLocation: lastp];
                        self.distance = pathway.distance;
                    }
                }
                return self;
}
- (void) postPath: (Pathway *) pathway completion: (PFBooleanResultBlock _Nullable) completion {
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            pathway.pathId = self.objectId;
            [pathway saveInBackgroundWithBlock: completion];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



- (void) drawPathToMapWithLandmarks: (NSArray *) landmarks pathway: (Pathway *) pathway map: (GMSMapView *) mapview {
    // Draw Pathway
    if (pathway != nil && pathway.path.count > 0) {
        GMSMutablePath *pathLine = [GMSMutablePath path];
        for (PFGeoPoint *point in pathway.path) {
            [pathLine addLatitude:point.latitude longitude:point.longitude];
    
    GMSPolyline *pathpolyline = [GMSPolyline polylineWithPath: pathLine];
    pathpolyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
    pathpolyline.strokeWidth = 7.0;
    pathpolyline.map = mapview;
        }
    }
    
    // Draw landmarks
    if (landmarks != nil) {
        UIImage *hazardImage = [UIImage imageNamed:@"wildfire"];
        UIImage *landmarkImage = [UIImage imageNamed:@"colosseum"];
        for (Landmark *landmark in landmarks) {
            [landmark addToMap: mapview landmarkImage:landmarkImage hazardImage:hazardImage];
        }
    }
    
}

- (void) drawPathToMapWithLandmarksWithCompletion: (void (^)(NSError *, NSArray *, Pathway *)) completion map: (GMSMapView *) mapview {
    __block Pathway *bPathway = nil;
    __block NSArray *bLandmarks = nil;
    __block NSError *bError = nil;
    [Pathway GET: self.objectId completion:^(Pathway * _Nonnull pathway, NSError * _Nonnull error) {
        if (bError != nil) {
            return;
        }
        if (error != nil) {
            bError = error;
            completion(error, nil, nil);
            return;
        }
        if (bLandmarks != nil) {
            bPathway = pathway;
            [self drawPathToMapWithLandmarks:bLandmarks pathway: bPathway map: mapview];
            completion(error, bLandmarks, bPathway);
        } else {
            bPathway = pathway;
        }
    }];
    [Landmark getLandmarks: self.objectId completion:^(NSArray * _Nonnull landmarks, NSError * _Nonnull error) {
        if (bError != nil) {
            return;
        }
        if (error != nil) {
            bError = error;
            completion(error, nil, nil);
            return;
        }
        if (bPathway != nil) {
            bLandmarks = landmarks;
            [self drawPathToMapWithLandmarks: bLandmarks pathway:bPathway map:mapview];
            completion(error, bLandmarks, bPathway);
        } else {
            bLandmarks = landmarks;
        }
    }];
}

+ (nonnull NSString *)parseClassName {
    return @"Path";
}

+ (void) getUserPaths: (NSString *) userId completion: (void (^)(NSArray *, NSError *) )  completion{
    PFQuery *query = [PFQuery queryWithClassName: @"Path"];
    [query whereKey:@"authorId" containsString: [PFUser currentUser].objectId ];
    query.limit = 10;
    [query orderByDescending: @"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
