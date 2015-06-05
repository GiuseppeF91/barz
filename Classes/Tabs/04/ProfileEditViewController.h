//
//  ProfileEditViewController.h
//  bazr
//
//  Created by Jiang on 3/29/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppConstant.h"
#import "SVProgressHUD.h"

#import "camera.h"
#import "pushnotification.h"
#import "utilities.h"

@interface ProfileEditViewController : UIViewController



@property (nonatomic,retain) IBOutlet UITextField* labelUsername;


@property (nonatomic,retain) IBOutlet PFImageView* imageUser;


@property (nonatomic,retain) IBOutlet UITextField* phonenumber;

@end
