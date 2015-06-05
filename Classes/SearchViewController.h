//
//  SearchViewController.h
//  bazr
//
//  Created by Jiang on 3/23/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate>
@property (nonatomic,retain) IBOutlet UISearchBar* mSearchBar;

@end
