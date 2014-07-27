//
//  NonNetworkedStackOVerflowCommunicator.h
//  BrowseOverflow
//
//  Created by jata on 27/07/14.
//  Copyright (c) 2014 Marcin Olek. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface NonNetworkedStackOVerflowCommunicator : StackOverflowCommunicator

- (void)setReceivedData:(NSData *)data;
- (NSData *)receivedData;

@end
