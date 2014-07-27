//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by jata on 21/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@implementation StackOverflowCommunicator

@synthesize delegate;

- (void)launchConnectionForRequest:(NSURLRequest *)request
{
    [self cancelAndDiscardURLConnection];
    fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)fetchContentAtURL:(NSURL *)url errorHandler:(void (^)(NSError *))errorBlock successHandler:(void (^)(NSString *))successBlock
{
    fetchingURL = url;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    [self cancelAndDiscardURLConnection];
    [self launchConnectionForRequest:request];
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?tagged=%@&pagesize=20&site=stackoverflow",tag]] errorHandler:^(NSError *error) {
        [delegate searchingForQuestionsFailedWithError:error];
    } successHandler:^(NSString *objectNotation) {
        [delegate receivedQuestionsJSON:objectNotation];
    }];
}

- (void)downloadInformationForQuestionWithID:(NSUInteger)ident
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackexchange.com/2.2/questions/%d&site=stackoverflow&filter=!9YdnSJBlX",ident]] errorHandler:^(NSError *error) {
        [delegate fetchingQuestionBodyFailedWithError:error];
    } successHandler:^(NSString *objectNotation) {
        [delegate receivedQuestionBodyJSON:objectNotation];
    }];
}

- (void)downloadAnswersToQuestionWithID:(NSUInteger)ident
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackexchange.com/2.2/questions/%d/answers?site=stackoverflow&filter=!9YdnSK0R1",ident]] errorHandler:^(NSError *error) {
        [delegate fetchingAnswersFailedWithError:error];
    } successHandler:^(NSString *objectNotation) {
        [delegate receivedAnswerListJSON:objectNotation];
    }];
    
}

- (void)fetchBodyForQuestion:(NSUInteger)questionID
{
    [self downloadAnswersToQuestionWithID:questionID];
}

- (void)cancelAndDiscardURLConnection
{
    [fetchingConnection cancel];
    fetchingConnection = nil;
}

- (void)dealloc
{
    [fetchingConnection cancel];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain code:[httpResponse statusCode] userInfo:nil];
        errorHandler(error);
        [self cancelAndDiscardURLConnection];
    } else {
        receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    receivedData = nil;
    fetchingConnection = nil;
    fetchingURL = nil;
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    fetchingConnection = nil;
    fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    receivedData = nil;
    successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

@end

NSString *StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";
