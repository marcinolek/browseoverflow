//
//  QuestionListTableDataSource.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 30.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Topic;
@class QuestionSummaryCell;
@class AvatarStore;

@interface QuestionListTableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (strong) Topic *topic;
@property (weak) IBOutlet QuestionSummaryCell *summaryCell;
@end
