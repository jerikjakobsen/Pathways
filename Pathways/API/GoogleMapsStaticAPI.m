//
//  GoogleMapsStaticAPI.m
//  Pathways
//
//  Created by johnjakobsen on 7/16/21.
//

#import "GoogleMapsStaticAPI.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@implementation GoogleMapsStaticAPI


static NSString *_baseURL = nil;

+ (NSString *) baseURL {
    return _baseURL;
}

+ (void) setBaseURL:(NSString *)newBaseURL {
    if (_baseURL != newBaseURL) {
        _baseURL = newBaseURL;
    }
}

+ (instancetype) shared {
    static GoogleMapsStaticAPI *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype) init {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: @"GoogleAPIKey"];
    if (self = [super init]) {
        [self setKey: key];
        if (_baseURL == nil) {
            _baseURL = @"https://maps.googleapis.com/maps/api/staticmap?";
        }
    }
    
    return self;
}


- (void) getStaticMapImage: (Pathway *) pathway size: (NSNumber *) size completion: (void (^)(NSError *, UIImage *)) completion {
    // Reference Link: https://developers.google.com/maps/documentation/maps-static/start#url-size-restriction
    int skip = 0;
    int pathLength = pathway.path.count;
    if ( pathLength > 400) {
        int removePoints = pathLength - 400;
        if (removePoints <= 0) {
            skip = 0;
        } else {
            skip = pathLength/(400);
        }
    }

    NSMutableString *locations = [[NSMutableString alloc] init];
    int count = 0;
    for (PFGeoPoint *point in pathway.path) {
        if (skip == 0) {
            NSString *coord = [NSString stringWithFormat: @"%g,%g%%7C", point.latitude, point.longitude];
            [locations appendString: coord];
        } else {
            if (count == skip) {
                NSString *coord = [NSString stringWithFormat: @"%g,%g%%7C", point.latitude, point.longitude];
                [locations appendString: coord];
                count = 0;
            } else {
                count++;
            }
        }
        
    }
    if (locations.length > 0) {
        //remove the last '|'
        locations = [NSMutableString stringWithString: [locations substringToIndex: locations.length - 3]];
    }
    
    NSString *sizeStr = [NSString stringWithFormat:@"%@x%@",size, size];
    NSString *pathParameter = [NSString stringWithFormat: @"mapId=1dd1155d695f866b&size=%@&path=color:0x4ede94%%7Cweight:7%%7C%@&key=%@", sizeStr, locations, self.key];
    NSString *fullURLString = [NSString stringWithFormat:@"%@%@", [self baseURL] ,pathParameter];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:fullURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            completion(error, nil);
        } else {
            UIImage *image = [UIImage imageWithData: data];
            completion(error, image);
        }
    }];
    [task resume];
    
}

@end
