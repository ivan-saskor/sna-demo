#import <Foundation/Foundation.h>
#import "ServerConnectorCallback.h"

@interface ServerConnector : NSObject
{
    @private NSMutableArray      *_persons;
    
    @private ServerConnectorCallback *serverCallback;
}

- (NSData *)sendDataRequest;
@end
