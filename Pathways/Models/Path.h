//
//  Path.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>
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
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSNumber *hazardCount;
@property (nonatomic, strong) NSNumber *landmarkCount;

// Using initFromLocal and not init because parse does not allow init to set properties (Since the
// object will be set with data from the database)
- (instancetype) initFromLocal;

- (void) postPath: (Pathway *) pathway
       completion: (PFBooleanResultBlock _Nullable) completion;

- (NSArray *) drawPathToMapWithLandmarks: (NSArray *) landmarks pathway: (Pathway *) pathway map: (GMSMapView *) mapview;

- (void) drawPathToMapWithLandmarksWithCompletion: (void (^)(NSError *, NSArray *, Pathway *)) completion map: (GMSMapView *) mapview;

+ (void) getUserPathsWithLimit: (int) pathLimit userId: (NSString *) userId completion: (void (^)(NSArray *, NSError *) ) completion;

+ (void) drawPathMarksToMapInBackground: (CLLocation *) userLocation mapView: (GMSMapView *) mapView completion: (void (^)(bool succeeded, NSError * error, NSArray *, NSMutableDictionary *)) completion;

//Returns an array of the path markers created
+ (NSArray *) drawPathMarksToMap: (NSArray *) paths mapView: (GMSMapView *) mapView;

@end

NS_ASSUME_NONNULL_END
