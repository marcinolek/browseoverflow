//
//  QuestionSummaryCell.h
//  BrowseOverflow
//
//  Created by Marcin Olek on 30.07.2014.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSummaryCell : UITableViewCell

@property (strong) IBOutlet UILabel *titleLabel;
@property (strong) IBOutlet UILabel *scoreLabel;
@property (strong) IBOutlet UILabel *nameLabel;

@end
