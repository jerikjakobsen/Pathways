//
//  ParseAPIManager.h
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

NS_ASSUME_NONNULL_BEGIN
// This Class handles all the User related API requests
@interface ParseUserManager : NSObject

// Sign up User with Profile Picture
+ (void) registerUser: (NSString *) username email: (NSString *) email password: (NSString *) password profilePic: (UIImage *) profilePic completion: (void (^)(NSError *)) completion;


// Login USer
+ (void) loginUser: (NSString *) username  password: (NSString *) password completion: (void (^)(NSError *)) completion;
@end

NS_ASSUME_NONNULL_END
