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
    self.landmark = [Landmark new];
    self.landmark.location = [PFGeoPoint geoPointWithLocation: self.location];
    self.landmark.pathId = self.pathId;
    self.landmark.type = self.type;
    self.landmark.photos = [[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = TRUE;
    self.tabBarController.tabBar.hidden = TRUE;
    self.addLandmarkLabel.text = [NSString stringWithFormat:@"Add %@", self.type ];
    
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)onDone:(id)sender {
    self.landmark.name = self.titleTextField.text;
    self.landmark.details = self.descriptionTextView.text;
    self.landmark.createdAt = [NSDate now];
    [self.delegate addLandmark: self.landmark];
    [self dismissViewControllerAnimated:TRUE completion:nil];
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
    
    [self presentViewController: imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.landmark addPhoto: editedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end