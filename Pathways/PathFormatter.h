//
//  PathFormatter.h
//  Pathways
//
//  Created by johnjakobsen on 7/26/21.
//

#import <Foundation/Foundation.h>
#import "Pathway.h"

NS_ASSUME_NONNULL_BEGIN

@interface PathFormatter : NSObject

+ (NSMutableArray *) removeOutliars: (NSMutableArray *) pathway;

+ (NSMutableArray *) removeAllOutliars: (NSMutableArray *) pathway;
@end

NS_ASSUME_NONNULL_END
