//
//  BrowseOverflowViewController.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackOverflowManager.h"

@class TopicTableDelegate;
@class TopicTableDataSource;
@class BrowseOverflowConfigurationObject;

@interface BrowseOverflowViewController : UIViewController <StackOverflowManagerDelegate>

@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject<UITableViewDataSource,UITableViewDelegate> *dataSource;
@property (strong) BrowseOverflowConfigurationObject *objectConfiguration;
@property (strong) StackOverflowManager *manager;

- (void)userDidSelectTopicNotification:(NSNotification *)note;
- (void)userDidSelectQuestionNotification:(NSNotification *)note;

@end
