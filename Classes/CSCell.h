//
//  CSCell.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by Jamz Tang on 8/1/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *countofBidButton;

@property (weak, nonatomic) IBOutlet UIButton *countofViewButton;

@property (weak, nonatomic) IBOutlet UIButton *countofMessageButton;

@property (weak, nonatomic) IBOutlet UIButton *entireButton;


@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end
