//
//  AnswerListTableDataSource.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 31.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Question;
@class AvatarStore;
@interface QuestionDetailDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (strong) Question *question;
@property (strong) AvatarStore *avatarStore;
@end
