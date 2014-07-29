//
//  EmptyTableViewDataSource.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;

extern NSString *TopicTableDidSelectTopicNotification;

@interface TopicTableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

- (void)setTopics:(NSArray *)newTopics;

@end
