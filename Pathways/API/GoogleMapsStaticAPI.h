//
//  GoogleMapsStaticAPI.h
//  Pathways
//
//  Created by johnjakobsen on 7/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleMapsStaticAPI : NSObject

+ (instancetype) shared;

@property (weak, nonatomic, readonly) NSString *baseURL;
@property (weak, nonatomic) NSURLSession *session;

+ (NSString *) decToBin: (NSNumber *) dec;
+ (NSString *) leftShift: (NSString *) bin;
+ (NSNumber *) binToDec: (NSString *) bin;
+ (NSString *) invert: (NSString *) bin;
+ (NSString *) decToBin2ComplementWith8digits:(NSNumber *)dec;
+ (NSMutableArray *) breakIntoGroupsOf5ReverseOrder: (NSString *) bin;
@end

NS_ASSUME_NONNULL_END
