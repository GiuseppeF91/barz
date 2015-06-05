//
//  RightMenuViewController.m
//  bazr
//
//  Created by Jiang on 3/4/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "RightMenuViewController.h"
#import "AppConstant.h"
@interface RightMenuViewController ()

@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    colorArray = @[[UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], [UIColor magentaColor], [UIColor purpleColor], [UIColor yellowColor]];
    [self.categoryTableView setBackgroundView:nil];
    self.categoryTableView.opaque = NO;
    [self.categoryTableView setBackgroundColor:[UIColor clearColor]];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    
    // Do any additional setup after loading the view from its nib.
}


//-------------------------------------------------------------------------------------------------------------------------------------------------



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
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //
        // Create the cell.
        //
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];
        
       
        
        
    }
    
    int buttonwidth = [UIScreen mainScreen].bounds.size.width*0.4;
    
    UIButton * tempBtn = [[UIButton alloc] initWithFrame: CGRectMake(buttonwidth*1.5+18,5,buttonwidth-28,35)];
    
    tempBtn.tag = indexPath.row-1;
    [tempBtn addTarget:self action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString* titleofCategory;
    
    if (indexPath.row == 0) {
        titleofCategory = @"All";
        self.allbtn = tempBtn;
    }else
    {
        titleofCategory = [[self.categoryArray objectAtIndex:indexPath.row-1] objectForKey:@"title"];
    }
    
    if ([APP_DELEGATE.categoryDic objectForKey:titleofCategory] != nil ) {
        
        [tempBtn setBackgroundColor:[UIColor grayColor]];
        tempBtn.selected = true;
    }else
    {
        int colorindex = indexPath.row % colorArray.count;
        
        [tempBtn setBackgroundColor:[colorArray objectAtIndex:colorindex]];

        tempBtn.selected= false;
    }
    
    tempBtn.layer.cornerRadius = 6;
    [tempBtn setTitle: titleofCategory forState:UIControlStateNormal];
    [cell.contentView addSubview:tempBtn];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

-(void)clickCategoryButton:(id) sender
{
    UIButton* tmp = (UIButton*)sender;
    
    tmp.selected = !tmp.selected;
    
    
    if (tmp.tag == -1) {
        
        
        if (tmp.selected) {
        
            [self.delegate addAll];
        }
        
        
    }else{
    
    
        if (tmp.selected) {
        
      
            [self.delegate addorRemoveCategory:[[self.categoryArray objectAtIndex:tmp.tag] objectForKey:@"title"] state:YES];
        
       
            
    
        }else
        {
    
            [self.delegate addorRemoveCategory:[[self.categoryArray objectAtIndex:tmp.tag] objectForKey:@"title"] state:NO];
     
            
    
        
    
        }
    }
    
    
    [self.categoryTableView reloadData];
    
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
