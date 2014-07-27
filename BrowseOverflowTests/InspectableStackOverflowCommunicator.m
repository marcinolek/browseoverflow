//
//  InspectableStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"

@implementation InspectableStackOverflowCommunicator

- (NSURL *)URLToFetch
{
    return fetchingURL;
}

- (NSURLConnection *)currentURLConnection
{
    return fetchingConnection;
}


@end
