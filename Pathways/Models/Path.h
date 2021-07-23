//
//  Path.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject.h>
#import <CoreLocation/CLLocation.h>
#import "Pathway.h"
#import <GoogleMaps/GMSMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface Path : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *timeElapsed;
@property (nonatomic) PFGeoPoint *startPoint;
@property (nonatomic, strong) NSDate *startedAt;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *pathId;
@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSNumber *hazardCount;
@property (nonatomic, strong) NSNumber *landmarkCount;

- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            startPoint: (PFGeoPoint *) startPoint
            distance: (NSNumber *) distance
            authorId: (NSString *) authorId;

- (instancetype) init: (NSString *) name
            timeElapsed: (NSNumber *) timeElapsed
            authorId: (NSString *) authorId
            pathway: (Pathway *) pathway;

- (void) postPath: (Pathway *) pathway
       completion: (PFBooleanResultBlock _Nullable) completion;

- (NSArray *) drawPathToMapWithLandmarks: (NSArray *) landmarks pathway: (Pathway *) pathway map: (GMSMapView *) mapview;

- (void) drawPathToMapWithLandmarksWithCompletion: (void (^)(NSError *, NSArray *, Pathway *)) completion map: (GMSMapView *) mapview;

+ (void) getUserPaths: (NSString *) userId completion: (void (^)(NSArray *, NSError *) ) completion;

@end

NS_ASSUME_NONNULL_END
