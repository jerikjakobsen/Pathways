//
//  GoogleMapsStaticAPI.m
//  Pathways
//
//  Created by johnjakobsen on 7/16/21.
//

#import "GoogleMapsStaticAPI.h"
#import "Pathway.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
@interface GoogleMapsStaticAPI()

@property (nonatomic, weak) NSString *key;

@end

@implementation GoogleMapsStaticAPI

static NSString *_baseURL = @"http://maps.googleapis.com/maps/api/staticmap";
static NSURLSession *_session;

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
        self.key = key;
        self.session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue] ];
    }
    
    return self;
}

- (void) getStaticMapImage: (Pathway *) pathway size: (NSNumber *) size {
    NSMutableString *locations = [[NSMutableString alloc] init];
    for (PFGeoPoint *point in pathway.path) {
        NSString *coord = [NSString stringWithFormat: @"%f,%f|", point.latitude, point.longitude];
        [locations appendString: coord];
    }
    NSString *sizeStr = [NSString stringWithFormat:@"%@x%@",size, size ];
}

@end
