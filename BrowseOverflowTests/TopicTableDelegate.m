//
//  EmptyTableViewDelegate.m
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "TopicTableDelegate.h"
#import "TopicTableDataSource.h"
@implementation TopicTableDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:[self.tableDataSource topicForIndexPath:indexPath] userInfo:nil];
}

@end

NSString *TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";
