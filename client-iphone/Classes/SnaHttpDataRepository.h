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
    @private ServerConnector    *_connector;
    
    @private NSMutableArray     *_persons;
    @private NSMutableArray     *_messages;
    @private NSData             *_data;
}
- (id) initWithConnector:(ServerConnector *)connector;
@end
