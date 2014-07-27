//
//  NonNetworkedStackOVerflowCommunicator.m
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "NonNetworkedStackOVerflowCommunicator.h"

@implementation NonNetworkedStackOVerflowCommunicator

- (void)launchConnectionForRequest: (NSURLRequest *)request
{
    
}

- (void)setReceivedData:(NSData *)data {
    receivedData = [data mutableCopy];
}

- (NSData *)receivedData {
    return [receivedData copy];
}
@end
