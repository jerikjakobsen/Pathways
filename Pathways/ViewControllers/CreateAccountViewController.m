//
//  CreateAccountViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import "CreateAccountViewController.h"
#import "ParseUserManager.h"
@interface CreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.secureTextEntry = TRUE;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapShowPassword:(id)sender {
    //Handles password text field being emptied from switching secure state
    NSString *pretext;
    if (self.passwordTextField.secureTextEntry) {
        pretext = self.passwordTextField.text;
    }
    [self.showPasswordButton setSelected: !self.showPasswordButton.isSelected];
    self.passwordTextField.secureTextEntry = !self.showPasswordButton.isSelected;
    if (!self.passwordTextField.secureTextEntry) {
        self.passwordTextField.text = pretext;
    }
}
- (IBAction)onSignup:(id)sender {
    [ParseUserManager registerUser:self.usernameTextField.text email: self.emailTextField.text password:self.passwordTextField.text profilePic:self.profileImageView.image completion:^(NSError * error) {
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
            [self performSegueWithIdentifier:@"CreateAccountToHome" sender:nil];
        }
    }];
    
}

@end
