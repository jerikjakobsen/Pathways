//
//  NewPathBottomView.m
//  Pathways
//
//  Created by johnjakobsen on 7/23/21.
//

#import "NewPathBottomView.h"

@implementation NewPathBottomView

- (id) init {
    if (self = [super init]) {
        [self initSubviews];
        return self;
    }
    return nil;
}


- (id) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder: coder]) {
        [self initSubviews];
        return self;
    }
    return nil;
}

- (void) initSubviews {
    UINib *nib = [UINib nibWithNibName: @"NewPathBottomView" bundle:nil];
    [nib instantiateWithOwner: self options:nil];
    self.contentView.frame = self.bounds;
    self.contentView.layer.cornerRadius = 20;
    self.contentView.layer.maskedCorners =  kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self addSubview: self.contentView];
}

@end
