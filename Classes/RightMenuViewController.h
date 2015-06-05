//
//  RightMenuViewController.h
//  bazr
//
//  Created by Jiang on 3/4/15.
//  Copyright (c) 2015 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RightMenuViewControllerDelegate <NSObject>
-(void)addAll;
- (void) addorRemoveCategory:(NSString*)objectId state:(BOOL)adding;
@end
@interface RightMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* colorArray;
}
@property (nonatomic, retain) UIButton* allbtn;
@property (nonatomic, retain) NSMutableArray* categoryArray;
@property (nonatomic, retain) IBOutlet UITableView* categoryTableView;
@property(nonatomic,weak,getter = getDelegate, setter = setDelegate:) id<RightMenuViewControllerDelegate> delegate;
@end
