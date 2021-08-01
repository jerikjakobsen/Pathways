//
//  ParseAPIManager.h
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import <Parse/PFFileObject.h>

NS_ASSUME_NONNULL_BEGIN
// This Class handles all the User related API requests
@interface ParseUserManager : NSObject

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

+ (void) registerUser: (NSString *) username email: (NSString *) email password: (NSString *) password profilePic: (UIImage *) profilePic completion: (void (^)(NSError *)) completion;

+ (void) loginUser: (NSString *) username  password: (NSString *) password completion: (void (^)(NSError *)) completion;

@end

NS_ASSUME_NONNULL_END
