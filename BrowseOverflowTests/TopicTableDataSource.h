//
//  EmptyTableViewDataSource.h
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;

@interface TopicTableDataSource : NSObject<UITableViewDataSource>

- (void)setTopics:(NSArray *)newTopics;
- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath;
@end
