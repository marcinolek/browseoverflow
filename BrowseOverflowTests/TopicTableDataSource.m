//
//  EmptyTableViewDataSource.m
//  BrowseOverflow
//
//  Created by jata on 28/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "TopicTableDataSource.h"
#import "Topic.h"
@interface TopicTableDataSource () {
    NSArray *topics;
}

@end

@implementation TopicTableDataSource

- (void)setTopics:(NSArray *)newTopics
{
    topics = newTopics;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    return topics.count;
}

static NSString *topicCellReuseIdentifier = @"TopicCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < topics.count);
    UITableViewCell *topicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopicCell"];
    if(!topicCell) {
        topicCell = [tableView dequeueReusableCellWithIdentifier:topicCellReuseIdentifier forIndexPath:indexPath];
    }
    topicCell.textLabel.text = [topics[indexPath.row] name];
    return topicCell;
}

- (Topic *)topicForIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    NSParameterAssert(indexPath.row < topics.count);
    return topics[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicTableDidSelectTopicNotification object:[self topicForIndexPath:indexPath] userInfo:nil];
}

@end

NSString *TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";
