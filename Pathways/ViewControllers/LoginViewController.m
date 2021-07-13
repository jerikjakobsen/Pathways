//
//  LoginViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import "LoginViewController.h"
#import "ParseUserManager.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didLogin:(id)sender {
    [ParseUserManager loginUser:self.usernameTextField.text password:self.passwordTextField.text completion:^(NSError * error) {
        if (error != nil) {
            NSLog(@"eroor");
            if (error.code == 1) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Field(s)" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction: action];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message: @"Please try again" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction: action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            [self performSegueWithIdentifier:@"LoginToHome" sender:nil];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
