//
//  LandmarkDetailsViewController.m
//  Pathways
//
//  Created by johnjakobsen on 7/21/21.
//

#import "LandmarkDetailsViewController.h"
#import "LandmarkPhotoCell.h"
#import "LandmarkDetailHeaderView.h"

@interface LandmarkDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *cellHeaderId;

@end

@implementation LandmarkDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellHeaderId = @"Header";
    UITapGestureRecognizer *tappedBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    tappedBackground.delegate = self;
    [self.view addGestureRecognizer: tappedBackground];
    self.collectionView.layer.cornerRadius = 10;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self ;
    UINib *nib = [UINib nibWithNibName:@"LandmarkPhotoCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"LandmarkPhotoCell"];
    
    [self.collectionView registerClass:LandmarkDetailHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier: self.cellHeaderId];
}

- (void) configureConstraintsOnParentView: (UIView *) parentView {
    self.view.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *leftConstraint = [self.view.leadingAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.leadingAnchor constant:0.0];
    [leftConstraint setActive: YES];
    NSLayoutConstraint *rightConstraint = [self.view.trailingAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.trailingAnchor constant:0.0];
    [rightConstraint setActive: YES];
    
    if (self.showOnlySafeArea) {
    NSLayoutConstraint *bottomConstraint = [self.view.bottomAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.bottomAnchor constant:0.0];
    [bottomConstraint setActive: YES];
    NSLayoutConstraint *topConstraint =  [self.view.topAnchor constraintEqualToAnchor: parentView.safeAreaLayoutGuide.topAnchor constant: 0.0];
    [topConstraint setActive: YES];
    } else {
        NSLayoutConstraint *bottomConstraint = [self.view.bottomAnchor constraintEqualToAnchor: parentView.bottomAnchor constant:0.0];
        [bottomConstraint setActive: YES];
        NSLayoutConstraint *topConstraint =  [self.view.topAnchor constraintEqualToAnchor: parentView.topAnchor constant: 0.0];
        [topConstraint setActive: YES];
    }
}

+ (LandmarkDetailsViewController *) detailViewAttachedToParentView: (UIViewController *) viewController safeArea: (bool) safeArea loadImagesLocally: (bool) loadImagesLocally landmark: (Landmark *) landmark {
    LandmarkDetailsViewController *detailViewController = [[LandmarkDetailsViewController alloc] init];
    detailViewController.showOnlySafeArea = safeArea;
    detailViewController.loadImagesLocally = loadImagesLocally;
    detailViewController.landmark = landmark;
    
    [detailViewController willMoveToParentViewController: viewController];
    [viewController addChildViewController: detailViewController];
    [detailViewController didMoveToParentViewController: viewController];
    [viewController.view addSubview: detailViewController.view];
    
    [detailViewController configureConstraintsOnParentView: viewController.view];
    
    // Animations
    detailViewController.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.0];
    detailViewController.collectionView.alpha = 0.0;
    [UIView animateWithDuration: 0.2 animations:^{
            detailViewController.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.3];
        detailViewController.collectionView.alpha = 1.0;
    }];
    
    return detailViewController;
}

- (void) didTapBackground:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration: 0.2 animations:^{
            self.view.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent: 0.0];
            self.collectionView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LandmarkPhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LandmarkPhotoCell" forIndexPath:indexPath];
    if (self.loadImagesLocally) {
        cell.photoImageView.image = self.landmark.localPhotos[indexPath.row];
    } else {
        cell.photoImageView.file = self.landmark.photos[indexPath.row];
        [cell.photoImageView loadInBackground];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.landmark.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width/3 - 4, (self.collectionView.frame.size.width/3 - 4) * 1.5 );
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    LandmarkDetailHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:self.cellHeaderId forIndexPath:indexPath];
    [header setDetails: self.landmark];
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSIndexPath *path = [NSIndexPath indexPathForRow: 0 inSection:section];
    UICollectionReusableView *header = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath: path];
    CGSize size = [((LandmarkDetailHeaderView *) header).titleLabel systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
    NSLog(@"%f %f", size.height, size.width);
    return CGSizeMake(self.view.frame.size.width, 60);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return FALSE;
    }
    return TRUE;
}

@end
