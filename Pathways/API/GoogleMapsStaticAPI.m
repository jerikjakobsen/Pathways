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
// TODO: Implement the google polyline algorithm https://developers.google.com/maps/documentation/utilities/polylinealgorithm
//
//+ (NSString *) decToBin: (NSNumber *) dec {
//    unsigned long num = dec.unsignedLongValue;
//    NSString *bin = @"";
//    while (num > 0) {
//        bin =  [[NSString stringWithFormat: @"%d", num & 1] stringByAppendingString: bin];
//        num = num >> 1;
//    }
//    return bin;
//}
//
//+ (NSString *) decToBin2ComplementWith8digits:(NSNumber *)dec {
//    if (dec.intValue > 0) {
//        return [self decToBin: dec];
//    } else {
//        NSString *bin = [self decToBin: @(dec.intValue * -1)];
//        if (bin.length < 32) {
//            NSString *zeros = [[NSString alloc] init];
//            for (int i = 0; i < 32-bin.length; i ++) {
//                zeros = [zeros stringByAppendingString:@"0"];
//            }
//            bin = [zeros stringByAppendingString: bin];
//        }
//        NSString *invertedBin = [self invert: bin];
//        NSNumber *invertedBinNum = [self binToDec: invertedBin];
//        NSNumber *negDecAdd1 = @(invertedBinNum.unsignedLongValue + 1);
//        NSLog(@"%lu", invertedBinNum.unsignedLongValue + 1);
//        return [self decToBin: negDecAdd1];
//    }
//    return @"0";
//}
//
//+ (NSNumber *) binToDec: (NSString *) bin {
//    unsigned long dec = 0;
//    for (int i = bin.length - 1; i >= 0; i --) {
//        NSString *val = [NSString stringWithFormat: @"%C", [bin characterAtIndex:i]];
//        int valNum = [val intValue];
//        dec += valNum * pow(2,bin.length - i-1);
//    }
//
//    return @(dec);
//}
//
//+ (NSString *) leftShift: (NSString *) bin {
//    return [NSString stringWithFormat:@"%@0", bin];
//}
//
//+ (NSString *) invert: (NSString *) bin {
//    NSString *invertedNum = @"";
//    for (int i = 0; i < bin.length; i ++) {
//        NSString *val = [NSString stringWithFormat: @"%C", [bin characterAtIndex:i]];
//        if ([val isEqualToString: @"1"]) {
//            invertedNum = [invertedNum stringByAppendingString:@"0"];
//        } else {
//            invertedNum = [invertedNum stringByAppendingString:@"1"];
//        }
//    }
//    return invertedNum;
//}
//
//+ (NSMutableArray *) breakIntoGroupsOf5ReverseOrder: (NSString *) bin {
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    NSString *bits = [[NSString alloc] init];
//    for (int i = bin.length - 1; i >= 0; i --) {
//        bits = [[NSString stringWithFormat:@"%C", [bin characterAtIndex: i] ] stringByAppendingString:bits];
//        if (arr.count == 0) {
//            [arr addObject: bits];
//        } else {
//            NSString *lastChunk = arr.lastObject;
//            if (lastChunk.length == 5) {
//                bits = [NSString stringWithFormat:@"%C", [bin characterAtIndex: i] ];
//                [arr addObject:bits];
//            } else {
//            arr[arr.count-1] = bits;
//            }
//        }
//    }
//    NSString *lastBits = arr.lastObject;
//    if (lastBits.length < 5) {
//        NSString *zeros = [[NSString alloc] init];
//        for (int i = 0; i < 5-bin.length; i ++) {
//            zeros = [zeros stringByAppendingString:@"0"];
//        }
//        arr[arr.count - 1] = [zeros stringByAppendingString: bin];
//    }
//    return arr;
//}

@end
