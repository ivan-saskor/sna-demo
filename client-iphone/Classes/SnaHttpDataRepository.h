//
//  SnaDataRepository.h
//  client-iphone
//
//  Created by Bruno Batarelo on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConnector.h"

@interface SnaHttpDataRepository : NSObject
{
    ServerConnector *_connector;
}
- (id) initWithConnector:(ServerConnector *)connector;
@end
