//
//  Path.m
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import "Path.h"
#import "Landmark.h"
#import <Parse/PFGeoPoint.h>
#import <Parse/PFQuery.h>
#import <GoogleMaps/GMSPolyline.h>
#import <GoogleMaps/GMSMutablePath.h>
#import <GoogleMaps/GMSMarker.h>
#import <GoogleMaps/GMSMarker+Premium.h>
#import "PathFormatter.h"
#import "GoogleMapsStaticAPI.h"
#import "ParseUserManager.h"

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

- (instancetype) initFromLocal {
    if (self = [super init]) {
        self.name = @"";
        self.startedAt = [NSDate now];
        self.hazardCount = @(0);
        self.landmarkCount = @(0);
        self.authorId = @"";
        self.pathId = @"";
    }
    return self;
}

- (void) postPath: (Pathway *) pathway completion: (PFBooleanResultBlock _Nullable) completion {
    pathway.path = [PathFormatter removeAllOutliars:pathway.path];
    [[GoogleMapsStaticAPI shared] getStaticMapImage:pathway size:@640 completion:^(NSError *error, UIImage *image) {
        if (error != nil) {
            completion(FALSE, error);
        } else {
            self[@"map_image"] = [ParseUserManager getPFFileFromImage: image];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    pathway.pathId = self.objectId;
                    
                    [pathway postPathway: completion];
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
    }];
}

- (NSArray *) drawPathToMapWithLandmarks: (NSArray *) landmarks pathway: (Pathway *) pathway map: (GMSMapView *) mapview {
    // Draw Pathway
    if (pathway != nil && pathway.path.count > 0) {
        GMSMutablePath *pathLine = [GMSMutablePath path];
        for (PFGeoPoint *point in pathway.path) {
            [pathLine addLatitude:point.latitude longitude:point.longitude];
        }
        GMSPolyline *pathpolyline = [GMSPolyline polylineWithPath: pathLine];
        pathpolyline.strokeColor = [UIColor colorWithRed:78.0/255.0 green:222.0/255.0 blue:147.0/255.0 alpha:1.0];
        pathpolyline.strokeWidth = 6.0;
        pathpolyline.map = mapview;
    }
    // Draw landmarks
    NSMutableArray *landmarkers = [[NSMutableArray alloc] init];
    if (landmarks != nil) {
        UIImage *hazardImage = [UIImage imageNamed:@"wildfire"];
        UIImage *landmarkImage = [UIImage imageNamed:@"colosseum"];
        for (Landmark *landmark in landmarks) {
            [landmarkers addObject: [landmark addToMap: mapview landmarkImage: landmarkImage hazardImage:hazardImage]];
        }
    }
    return landmarkers;
    
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

+ (void) getPathsNear: (CLLocation *) userLocation completion: (void (^)(NSArray *, NSError *)) completion {
    PFGeoPoint *geopoint = [PFGeoPoint geoPointWithLocation: userLocation];
    PFQuery *query = [PFQuery queryWithClassName: @"Path"];
    [query whereKey: @"startPoint" nearGeoPoint:geopoint withinMiles: 2.0];
    [query findObjectsInBackgroundWithBlock: completion];
}

+ (NSArray *) drawPathMarksToMap: (NSArray *) paths mapView: (GMSMapView *) mapView {
    NSMutableArray *pathMarkers = [[NSMutableArray alloc] init];
    for (Path *path in paths) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:path.startPoint.latitude longitude:path.startPoint.longitude];
        GMSMarker *marker = [GMSMarker markerWithPosition: location.coordinate];
        marker.title = path.name;
        marker.collisionBehavior = GMSCollisionBehaviorRequiredAndHidesOptional;
        marker.map = mapView;
        [pathMarkers addObject: marker];
    }
    return pathMarkers;
}

+ (void) drawPathMarksToMapInBackground: (CLLocation *) userLocation mapView: (GMSMapView *) mapView completion: (void (^)(bool succeeded, NSError * error, NSArray *pathMarkers)) completion {
    [self getPathsNear:userLocation completion:^(NSArray *paths, NSError *error) {
        if (error != nil) {
            completion(FALSE, error, nil);
        } else {
            completion(TRUE, nil, [self drawPathMarksToMap:paths mapView:mapView]);
        }
        
    }];
}

+ (nonnull NSString *) parseClassName {
    return @"Path";
}

+ (void) getUserPathsWithLimit: (int) pathLimit userId: (NSString *) userId completion: (void (^)(NSArray *, NSError *) ) completion {
    PFQuery *query = [PFQuery queryWithClassName: @"Path"];
    [query whereKey:@"authorId" containsString: [PFUser currentUser].objectId ];
    query.limit = pathLimit;
    [query orderByDescending: @"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];
}

@end
