//
//  EmptyTableViewDelegate.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicTableDataSource;

extern NSString *TopicTableDidSelectTopicNotification;

@interface TopicTableDelegate : NSObject<UITableViewDelegate>
@property (strong) TopicTableDataSource *tableDataSource;
@end
