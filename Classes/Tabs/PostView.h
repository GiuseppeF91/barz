//
//  PostView.h
//  bazr
//
//  Created by Justin Lynch on 1/28/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightMenuViewController.h"


@interface PostView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, RightMenuViewControllerDelegate>
{
    
}
@property (nonatomic, retain) IBOutlet UITableView* maintable;


@property (nonatomic, retain) IBOutlet UIView* ViewForPic;


@property (nonatomic, retain) IBOutlet UIDatePicker* pickerview;


@property (nonatomic, retain) UITextField* txtTitle;

@property (nonatomic, retain) UITextField* txtCategory;

@property (nonatomic, retain) UITextField* txtPayment;

@property (nonatomic, retain) UITextView* txtDescription;
@property (nonatomic, retain) NSDate * expireDate;



@end
