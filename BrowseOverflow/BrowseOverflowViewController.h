//
//  BrowseOverflowViewController.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseOverflowViewController : UIViewController
@property (strong) UITableView *tableView;
@property (strong) id<UITableViewDataSource> dataSource;
@property (strong) id<UITableViewDelegate> tableViewDelegate;
@end
