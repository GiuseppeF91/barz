//
//  ProfileEditViewController.m
//  bazr
//
//  Created by Jiang on 3/29/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController
@synthesize imageUser,labelUsername,phonenumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(actionSave:)];
    
    
    PFUser *user = [PFUser currentUser];
    
    [imageUser setFile:user[PF_USER_PICTURE]];
    [imageUser loadInBackground];
    
    self.labelUsername.text = user[PF_USER_FULLNAME];
    if (user[PF_USER_PHONENUBER] != nil) {
        
        self.phonenumber.text = user[PF_USER_PHONENUBER];
    }

    
    imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
    imageUser.layer.masksToBounds = YES;
    
    self.imageUser.clipsToBounds = YES;
    self.imageUser.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.imageUser.layer.borderWidth=3.0;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionSave:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [self.view endEditing:YES];
    
    
    if ([labelUsername.text isEqualToString:@""] == NO && [phonenumber.text isEqualToString:@""] == NO)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

        PFUser *user = [PFUser currentUser];
        user[PF_USER_FULLNAME] = labelUsername.text;

        user[PF_USER_FULLNAME_LOWER] = [labelUsername.text lowercaseString];

        user[PF_USER_PHONENUBER] = phonenumber.text;
        
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (error == nil)
            {
                [SVProgressHUD showSuccessWithStatus:@"Saved."];
            }
            else [SVProgressHUD showSuccessWithStatus:@"Network error."];
        }];
    }
    else [SVProgressHUD showSuccessWithStatus:@"Name field must be set."];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionPhoto:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ShouldStartPhotoLibrary(self, YES);
}




//-------------------------------------------------------------------------------------------------------------------------------------------------

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (image.size.width > 140) image = ResizeImage(image, 140, 140);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
    [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    imageUser.image = image;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (image.size.width > 30) image = ResizeImage(image, 30, 30);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
    [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFUser *user = [PFUser currentUser];
    user[PF_USER_PICTURE] = filePicture;
    user[PF_USER_THUMBNAIL] = fileThumbnail;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error != nil) [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
