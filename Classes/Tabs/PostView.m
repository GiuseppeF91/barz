//
//  PostView.m
//  bazr
//
//  Created by Justin Lynch on 1/28/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//


#import <Parse/Parse.h>


#import "AppConstant.h"
#import "camera.h"
#import "pushnotification.h"
#import "utilities.h"

#import "PostView.h"

@interface PostView ()
//@property (strong, nonatomic) IBOutlet UIView *viewHeader;
//@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
//
//@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
//@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
//
//@property (strong, nonatomic) IBOutlet UITextField *fieldName;

@end


@implementation PostView

//@synthesize viewHeader, imageUser;
//@synthesize cellName, cellButton;
//@synthesize fieldName;
//
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_post"]];
        self.tabBarItem.title = @"";
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        self.title = nil;
        
    }
    return self;
}

-(IBAction)clickCancel:(id)sender
//
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)clickDone:(id)sender
{
    [self.ViewForPic setHidden:YES];
    
    self.expireDate = self.pickerview.date;
    
}
-(IBAction)clickPost:(id)sender
//
{
    
    if ([self.txtTitle.text  isEqual: @""] || [self.txtDescription.text  isEqual: @""] ) {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Ooops" message:@"Please fill all info" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
    object[PF_CHATROOMS_NAME] = self.txtTitle.text;
    object[PF_CHATROOMS_DESCRIPTION] = self.txtDescription.text;
    
    
    NSArray* categoryArray = [APP_DELEGATE.categoryDic allKeys];
    
    
    object[PF_CHATROOMS_CATEGORY] = categoryArray;
    
    object[PF_CHATROOMS_POSTDATE] = [NSDate date];
    
    if (self.expireDate == nil) {
        
        
        NSDate *date = [NSDate date];
       
        
        int hoursToAdd = 1;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:hoursToAdd];
        NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
       
        object[PF_CHATROOMS_EXPIREDATE] = newDate;
        
        
    }else
    {
        NSTimeInterval diff = [self.expireDate timeIntervalSinceDate:[NSDate date]];
        
        if (diff < 3600) {
            NSDate *date = [NSDate date];
            
            
            int hoursToAdd = 1;
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setHour:hoursToAdd];
            NSDate *newDate= [calendar dateByAddingComponents:components toDate:date options:0];
            
            object[PF_CHATROOMS_EXPIREDATE] = newDate;
        }else
            object[PF_CHATROOMS_EXPIREDATE] = self.expireDate;
    }
    
    object[PF_CHATROOMS_BUDGET] = self.txtPayment.text;
    
    
    
    PFGeoPoint* curlocation = [PFGeoPoint geoPointWithLatitude:APP_DELEGATE.currentLocation.coordinate.latitude longitude:APP_DELEGATE.currentLocation.coordinate.longitude];
    
    
    object[PF_CHATROOMS_LOCATION] = curlocation;
    
    object[PF_CHATROOMS_POSTER] =  [PFUser currentUser];
    
    object[PF_CHATROOMS_AWARDED] = [NSNumber numberWithBool:false];
    
    object[PF_CHATROOMS_COMPLETE] = [NSNumber numberWithBool:false];
    
    object[PF_CHATROOMS_COUNT_BID] = [NSNumber numberWithInt:0];
    object[PF_CHATROOMS_COUNT_MSG] = [NSNumber numberWithInt:0];
    object[PF_CHATROOMS_COUNT_VIEW] = [NSNumber numberWithInt:0];
    object[PF_CHATROOMS_BADGE] = [NSNumber numberWithInt:0];
    object[PF_CHATROOMS_BADGEWORKER] = [NSNumber numberWithInt:0];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [SVProgressHUD dismiss];
         }
         else [SVProgressHUD showErrorWithStatus:@"Network error."];
     }];

    
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    
    APP_DELEGATE.categoryDic = [NSMutableDictionary dictionary];
       
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: case 1: case 2:
            return 44;
            break;
        case 3:
            return 44*7;
            break;
            
        default:
            return  44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //
        // Create the cell.
        //
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        
        
        switch (indexPath.row) {
            case 0:
            {
                UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 30)];
                [lblTitle setText:@"Title:"];
                [lblTitle setTextColor:[UIColor grayColor]];
                [lblTitle sizeToFit];
                
                int widthoftitle = lblTitle.frame.size.width;
                
                
                self.txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(widthoftitle+12, 8, 200, 30)];
                
                UILabel* lblNow =[[UILabel alloc] initWithFrame:CGRectMake(240, 12, 50, 30)];
                [lblNow setText:@"Now"];
                [lblNow setTextColor:[UIColor grayColor]];
                [lblNow sizeToFit];
                
                
                UIButton* btnCalendar = [[UIButton alloc]initWithFrame:CGRectMake(270, 5, 50, 30)];
                [btnCalendar setImage:[UIImage imageNamed:@"calender.png"] forState:UIControlStateNormal];
                [btnCalendar addTarget:self action:@selector(clickCalenderButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [cell.contentView addSubview:lblTitle];
                [cell.contentView addSubview:self.txtTitle];
                [cell.contentView addSubview:lblNow];
                [cell.contentView addSubview:btnCalendar];
                
                
                
                
            }
                break;
                
            case 1:
            {
                UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 30)];
                [lblTitle setText:@"Category:"];
                [lblTitle setTextColor:[UIColor grayColor]];
                [lblTitle sizeToFit];
                
                int widthoftitle = lblTitle.frame.size.width;
                
                
                self.txtCategory = [[UITextField alloc] initWithFrame:CGRectMake(widthoftitle+12, 10, 200, 30)];
                
                [self.txtCategory setUserInteractionEnabled:NO];
                
                UIButton* btnCategory = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
                [btnCategory addTarget:self action:@selector(clickCategoryButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [cell.contentView addSubview:lblTitle];
                [cell.contentView addSubview:self.txtCategory];
                [cell.contentView addSubview:btnCategory];
                
                
            }
                break;
                
            case 2:
            {
                
                UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 30)];
                [lblTitle setText:@"Payment:"];
                [lblTitle setTextColor:[UIColor grayColor]];
                [lblTitle sizeToFit];
                
                int widthoftitle = lblTitle.frame.size.width;
                
                
                self.txtPayment = [[UITextField alloc] initWithFrame:CGRectMake(widthoftitle+12, 8, 150, 30)];
                [self.txtPayment setKeyboardType:UIKeyboardTypeNumberPad];
                
                UIButton* btnPaypal = [[UIButton alloc]initWithFrame:CGRectMake(240, 5, 42, 30)];
                [btnPaypal setImage:[UIImage imageNamed:@"paypal.png"] forState:UIControlStateNormal];
                [btnPaypal addTarget:self action:@selector(clickPaypalButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton* btnCredit = [[UIButton alloc]initWithFrame:CGRectMake(274, 5, 42, 30)];
                [btnCredit setImage:[UIImage imageNamed:@"creditcard.png"] forState:UIControlStateNormal];
                [btnCredit addTarget:self action:@selector(clickCreditButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [cell.contentView addSubview:lblTitle];
                [cell.contentView addSubview:self.txtPayment];
                [cell.contentView addSubview:btnPaypal];
                [cell.contentView addSubview:btnCredit];
                
                
                
            }
                break;
                
            case 3:
            {
                
                UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 50, 30)];
                [lblTitle setText:@"Description:"];
                [lblTitle setTextColor:[UIColor grayColor]];
                [lblTitle sizeToFit];
                
                int widthoftitle = lblTitle.frame.size.width;
                
                
                self.txtDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 290, 44*6)];
                [self.txtDescription setBackgroundColor:[UIColor clearColor]];
                
                [cell.contentView addSubview:lblTitle];
                [cell.contentView addSubview:self.txtDescription];
                
                
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
    return cell;
}

-(void) clickCalenderButton
{
    
    [self.view endEditing:true];
    [self.ViewForPic setHidden:NO];
    
    
}

-(void)clickCategoryButton
{
    [self.view endEditing:true];
    [APP_DELEGATE.sideviewController toggleRightPanel:self];
}

-(void)clickPaypalButton
{
    
}

-(void) clickCreditButton
{
    
}



- (void) addorRemoveCategory:(NSString*)objectId state:(BOOL)adding
{
    
    if (adding) {
        [APP_DELEGATE.categoryDic setObject:objectId forKey:objectId];
        [APP_DELEGATE.categoryDic removeObjectForKey:@"All"];
        
    }else
    {
        [APP_DELEGATE.categoryDic removeObjectForKey:objectId];
    }
    
    self.txtCategory.text = [NSString stringWithFormat:@"%d", APP_DELEGATE.categoryDic.count ];
    
}

-(void) addAll
{
    APP_DELEGATE.categoryDic = [NSMutableDictionary dictionary];
    [APP_DELEGATE.categoryDic  setObject:@"All" forKey:@"All"];
    self.txtCategory.text = @"All";
    
}



@end
