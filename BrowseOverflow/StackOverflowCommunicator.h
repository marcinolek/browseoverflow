//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowCommunicator : NSObject
- (void)searchForQuestionsWithTag:(NSString *)tag;
@end
