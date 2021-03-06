//
//  PFPurchaseTableViewCell.h
//  Parse
//
//  Created by Qian Wang on 5/21/12.
//  Copyright (c) 2012 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTableViewCell.h"

typedef enum {
    PFPurchaseTableViewCellStateNormal,
    PFPurchaseTableViewCellStateDownloading,
    PFPurchaseTableViewCellStateDownloaded
} PFPurchaseTableViewCellState;

@interface PFPurchaseTableViewCell : PFTableViewCell
@property (nonatomic, assign) PFPurchaseTableViewCellState state;
@property (nonatomic, strong, readonly) UILabel *priceLabel;
@property (nonatomic, strong, readonly) UIProgressView *progressView;
@end
