//
//  LandmarkDetailsViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/21/21.
//

#import "LandmarkDetailsViewController.h"
#import "LandmarkPhotoCell.h"

@interface LandmarkDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UIViewController *parent;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *landmarkName;
@property (weak, nonatomic) IBOutlet UILabel *landmarkDescription;
@property (weak, nonatomic) IBOutlet UIImageView *landmarkTypeImageView;
@property (strong, nonatomic) UIImage *hazardImage;
@property (strong, nonatomic) UIImage *landmarkImage;

@end

@implementation LandmarkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.landmarkImage = [UIImage imageNamed:@"colosseum"];
    self.hazardImage = [UIImage imageNamed:@"wildfire"];
    UITapGestureRecognizer *tappedBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    tappedBackground.delegate = self;
    [self.view addGestureRecognizer: tappedBackground];
    self.contentView.layer.cornerRadius = 10;
    
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self ;
    UINib *nib = [UINib nibWithNibName:@"LandmarkPhotoCell" bundle: nil];
    [self.photoCollectionView registerNib:nib forCellWithReuseIdentifier:@"LandmarkPhotoCell"];

}

- (void) configureConstraintsOnParentView: (UIView *) parentView {
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *bottomConstraint = [self.view.bottomAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.bottomAnchor constant:0.0];
    [bottomConstraint setActive: YES];
    NSLayoutConstraint *leftConstraint = [self.view.leadingAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.leadingAnchor constant:0.0];
    [leftConstraint setActive: YES];
    NSLayoutConstraint *rightConstraint = [self.view.trailingAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.trailingAnchor constant:0.0];
    [rightConstraint setActive: YES];
    NSLayoutConstraint *topConstraint =  [self.view.topAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.topAnchor constant: 0.0];
    [topConstraint setActive: YES];
}

- (void) addToParentView: (UIViewController *) viewController {
    [viewController addChildViewController: self];
    [viewController.view addSubview: self.view];
}

+ (LandmarkDetailsViewController *) detailViewAttachedToParentView: (UIViewController *) viewController {
    LandmarkDetailsViewController *detailViewController = [[LandmarkDetailsViewController alloc] init];
    detailViewController.parent = viewController;
    [detailViewController addToParentView: viewController];
    [detailViewController configureConstraintsOnParentView: viewController.view];
    detailViewController.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.0];
    detailViewController.contentView.alpha = 0.0;
    [UIView animateWithDuration: 0.2 animations:^{
            detailViewController.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.3];
        detailViewController.contentView.alpha = 1.0;
    }];
    return detailViewController;
}

- (void) setLandmarkDetail: (Landmark *) landmark {
    self.landmark = landmark;
    self.landmarkName.text = self.landmark.name;
    self.landmarkDescription.text = self.landmark.details;
    if ([landmark.type isEqualToString: @"Landmark"]) {
        [self.landmarkTypeImageView setImage: self.landmarkImage];
    } else {
        [self.landmarkTypeImageView setImage: self.hazardImage];
    }
    
}

- (void) didTapBackground:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration: 0.2 animations:^{
            self.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.0];
            self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandmarkPhotoCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"LandmarkPhotoCell" forIndexPath:indexPath];
    cell.photoImageView.file = self.landmark.photos[indexPath.row];
    [cell.photoImageView loadInBackground];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.landmark.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.photoCollectionView.frame.size.width/3 - 4, (self.photoCollectionView.frame.size.width/3 - 4) * 1.5 );
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return FALSE;
    }
    return TRUE;
}

@end
