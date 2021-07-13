//
//  Path.h
//  Pathways
//
//  Created by johnjakobsen on 7/13/21.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Path : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *timeElapsed;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic) CLLocationCoordinate2D startPoint;
@property (nonatomic) CLLocationCoordinate2D endPoint;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *pathId;
@property (nonatomic, strong) NSString *authorId;





@end

NS_ASSUME_NONNULL_END
