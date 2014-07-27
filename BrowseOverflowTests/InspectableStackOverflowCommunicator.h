//
//  InspectableStackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface InspectableStackOverflowCommunicator : StackOverflowCommunicator
- (NSURL *)URLToFetch;
- (NSURLConnection *)currentURLConnection;
@end
