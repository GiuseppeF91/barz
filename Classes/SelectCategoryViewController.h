//
//  SelectCategoryViewController.h
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"
@interface SelectCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, retain) NSMutableArray* categoryArray;
@end
