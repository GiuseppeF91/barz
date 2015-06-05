//
//  SearchViewController.m
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import "SearchViewController.h"
#import "AppConstant.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (APP_DELEGATE.searchText != nil) {
        
        self.mSearchBar.text = APP_DELEGATE.searchText;
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    APP_DELEGATE.searchText = searchBar.text;
    
    [self.navigationController popViewControllerAnimated:YES];
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
