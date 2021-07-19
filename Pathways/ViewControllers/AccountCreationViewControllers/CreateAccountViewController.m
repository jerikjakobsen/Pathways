//
//  CreateAccountViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/12/21.
//

#import "CreateAccountViewController.h"
#import "ParseUserManager.h"
@interface CreateAccountViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
}

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

- (IBAction)didTapView:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapProfileImageView:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController: imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = editedImage;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
