//
//  AddLandmarkViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/14/21.
//

#import "AddLandmarkViewController.h"
#import "Landmark.h"
#import <Parse/Parse.h>

@interface AddLandmarkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) Landmark *landmark;

@end

@implementation AddLandmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionTextView.layer.cornerRadius = 6;
    self.landmark = [[Landmark alloc] initFromLocal:self.location pathId:self.pathId type:self.type];
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = TRUE;
    self.addLandmarkLabel.text = [NSString stringWithFormat:@"Add %@", self.type ];
    
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)onDone:(id)sender {
    if (self.titleTextField.text.length < 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title too Short" message:@"Title must be at least 2 characters long" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        self.landmark.name = self.titleTextField.text;
        self.landmark.details = self.descriptionTextView.text;
        self.landmark.createdAt = [NSDate now];
        [self.delegate addLandmarkViewController:self didAddLandmark: self.landmark];
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
}

- (IBAction)onAddPhotos:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController: imagePickerVC animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.landmark addPhoto: editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
