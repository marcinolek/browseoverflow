//
//  BrowseOverflowViewController.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicTableDelegate;
@class TopicTableDataSource;

@interface BrowseOverflowViewController : UIViewController

@property (strong) UITableView *tableView;
@property (strong) id<UITableViewDataSource,UITableViewDelegate> dataSource;

@end
