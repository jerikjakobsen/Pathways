//
//  GoogleMapsStaticAPI.h
//  Pathways
//
//  Created by johnjakobsen on 7/16/21.
//

#import <Foundation/Foundation.h>
#import "Pathway.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleMapsStaticAPI : NSObject

+ (instancetype) shared;

- (void) getStaticMapImage: (Pathway *) pathway size: (NSNumber *) size completion: (void (^)(NSError *, UIImage *)) completion;

+ (NSString *) baseURL;
+ (void) setBaseURL: (NSString *) newBaseURL;

@property (weak, nonatomic, readonly) NSString *baseURL;
@property (strong, nonatomic) NSString *key;

@end

NS_ASSUME_NONNULL_END
