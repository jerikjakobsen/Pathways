//
//  ParseAPIManager.m
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import "ParseUserManager.h"
#import<Parse/Parse.h>

@implementation ParseUserManager
// Registers the user through parse and assigns a profile picture
+ (void) registerUser: (NSString *) username email: (NSString *) email password: (NSString *) password profilePic: (UIImage *) profilePic completion: (void (^)(NSError *)) completion {
    [self validateUser:username password:password completion:^(BOOL validated, NSString *message) {
            if (validated) {
                if (![self validateEmail:email]) {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setObject: @"Invalid email" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"com.JohnJakobsen.Pathways.ErrorDomain" code:1 userInfo:userInfo];
                    completion(error);
                    return;
                }
                PFUser *newUser = [PFUser user];
                newUser.username = username;
                newUser.password = password;
                newUser.email =  email;
                if (profilePic != nil) newUser[@"profile_image"] = [self getPFFileFromImage: profilePic];
                [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error != nil) NSLog(@"%@", error.localizedDescription);
                    else NSLog(@"Account creation successful");
                    completion(error);
                }];
            } else {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject: message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.JohnJakobsen.Pathways.ErrorDomain" code:1 userInfo:userInfo];
                completion(error);
            }
    }];
}


//Logins the user through parse and caches the current user on the device
+ (void) loginUser: (NSString *) username  password: (NSString *) password completion: (void (^)(NSError *)) completion {
    [self validateUser: username password:password completion:^(BOOL validated, NSString *message) {
            if (validated) {
                [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                    if (error != nil) NSLog(@"%@", error.localizedDescription);
                    else NSLog(@"User login successful");
                    completion(error);
                }];
            } else {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject: message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.JohnJakobsen.Pathways.ErrorDomain" code:1 userInfo:userInfo];
                completion(error);
            }

    }];
}

//Helper Methods


// Validates the username and password, accepts a callback function to return whether or not the use has
// been validated and if not the error message is placed in the message parameter (This parameter will be
// empty if the user was validated successfully)
+ (void) validateUser: (NSString *) username password: (NSString *) password completion: (void (^)(BOOL, NSString* ) ) completion {
    if (username.length < 3) {
        completion(FALSE, @"Username must be longer than 2 characters");
        return;
    }
    if (username.length > 20) {
        completion(FALSE, @"Username must be shorter than 20 characters");
        return;
    }
    if ([username containsString: @" "]) {
        completion(FALSE, @"Username must not contain spaces");
        return;
    }
    if (password.length < 6) {
        completion(FALSE, @"Password must be longer than 5 characters");
        return;
    }
    if ([password containsString:@" "]) {
        completion(FALSE, @"Password cannot contain spaces");
        return;
    }
    completion(TRUE, @"");
    
}

+ (BOOL) validateEmail: (NSString *) email {
    NSString *emailReg = @"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\\\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *test = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailReg];
    if ([test evaluateWithObject:email]) {
        NSLog(@"Doesnt work");
    }
    return [test evaluateWithObject:email];
}

// Turns the image into a file for parse to save
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
