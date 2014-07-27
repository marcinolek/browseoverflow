//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

@interface StackOverflowCommunicator : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
@protected
    NSURL *fetchingURL;
    NSURLConnection *fetchingConnection;
    NSMutableData *receivedData;
@private
    __weak id<StackOverflowCommunicatorDelegate> delegate;
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSString *);

}

@property (weak) id<StackOverflowCommunicatorDelegate> delegate;

- (void)searchForQuestionsWithTag:(NSString *)tag;
- (void)fetchBodyForQuestion:(NSUInteger)questionID;
- (void)downloadInformationForQuestionWithID:(NSUInteger)ident;
- (void)downloadAnswersToQuestionWithID:(NSUInteger)ident;
- (void)cancelAndDiscardURLConnection;

@end

extern NSString *StackOverflowCommunicatorErrorDomain;
