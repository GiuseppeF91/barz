//
//  PostedJobListViewController.h
//  bazr
//
//  Created by Jiang on 3/27/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import "AppConstant.h"
#import "SVProgressHUD.h"

@interface PostedJobListViewController  : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL upComing;
    
    NSMutableArray *chatrooms;
    
}
@property (nonatomic,retain) IBOutlet UITableView* tableView;

@property (nonatomic,retain) IBOutlet UISegmentedControl* segcontrol;
@end
