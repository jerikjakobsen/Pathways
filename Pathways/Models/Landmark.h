//
//  Landmark.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Parse/Parse.h>
#import <CoreLocation/CLLocation.h>
#import <UIKit/UIImage.h>
#import <GoogleMaps/GMSMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface Landmark : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *pathId;
@property (nonatomic, strong) NSString *landmarkId;
@property (nonatomic, strong) NSMutableArray *localPhotos;

- (instancetype) initFromLocal;

- (instancetype) initFromLocal: (CLLocation *) location pathId: (NSString *) pathId type: (NSString *) type;

- (void) addPhoto: (UIImage *) photo;

- (void) postLandmark:(PFBooleanResultBlock _Nullable) completion;

- (GMSMarker *) addToMap: (GMSMapView *) mapView landmarkImage: (UIImage *) landmarkImage hazardImage: (UIImage *) hazardImage;

+ (void) addLandmarksToMap: (NSArray *) landmarks mapView: (GMSMapView *) mapView landmarkImage: (UIImage *) landmarkImage hazardImage: (UIImage *) hazardImage;

+ (void) postLandmarks: (NSMutableArray *) landmarks
            pathId: (NSString *) pathId
            completion: (PFBooleanResultBlock _Nullable) completion;

+ (void) getLandmarks: (NSString *) pathId completion: (void (^)(NSArray *, NSError* )) completion;

@end

NS_ASSUME_NONNULL_END
