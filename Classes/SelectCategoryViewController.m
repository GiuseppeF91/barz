//
//  SelectCategoryViewController.m
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import <Parse/Parse.h>

#import "CategoryCellTableViewCell.h"

@interface SelectCategoryViewController ()

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"CategoryCellTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.categoryArray = [NSMutableArray arrayWithArray:APP_DELEGATE.categoryArray];
    [self.tableView reloadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
// numberOfSectionsInTableView:
//
// Return the number of sections for the table.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//
// tableView:numberOfRowsInSection:
//
// Returns the number of rows in a given section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.categoryArray.count+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* titleofCategory;
    
    if (indexPath.row == 0) {
        titleofCategory = @"All";
        [APP_DELEGATE.categoryDicForSearch removeAllObjects];
        
        
    }else
    {
        titleofCategory = [[self.categoryArray objectAtIndex:indexPath.row-1] objectForKey:@"title"];
        [APP_DELEGATE.categoryDicForSearch removeObjectForKey:@"All"];
        
    }
    
    if ([APP_DELEGATE.categoryDicForSearch objectForKey:titleofCategory] != nil ) {
    
    
        [APP_DELEGATE.categoryDicForSearch removeObjectForKey:titleofCategory];
    }else
    {
    
        [APP_DELEGATE.categoryDicForSearch setObject:titleofCategory forKey:titleofCategory];
        
    }
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"cell";
    
   
    
    CategoryCellTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    cell.categoryLabel.layer.cornerRadius = 18;
    cell.categoryLabel.clipsToBounds = YES;
    NSString* titleofCategory;
    
    if (indexPath.row == 0) {
        titleofCategory = @"All";
    }else
    {
        titleofCategory = [[self.categoryArray objectAtIndex:indexPath.row-1] objectForKey:@"title"];
    }
    
    
    cell.categoryLabel.text = titleofCategory;
    cell.categoryLabel.textAlignment = UITextAlignmentCenter;
    [cell.categoryLabel sizeToFit];
    
    CGRect frameofLabel = cell.categoryLabel.frame;
    frameofLabel.size.height +=  15;
    frameofLabel.size.width +=  30;
    
    

    [cell.categoryLabel setFrame:frameofLabel];
    
    if ([APP_DELEGATE.categoryDicForSearch objectForKey:titleofCategory] != nil ) {
        
        cell.categoryLabel.backgroundColor = [UIColor blueColor];
        cell.CheckButton.selected = true;
    }else
    {
        cell.CheckButton.selected = false;
        cell.categoryLabel.backgroundColor = [UIColor grayColor];
    }
    
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
