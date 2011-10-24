#import <Foundation/Foundation.h>
#import "ServerConnectorCallback.h"

@interface ServerConnector : NSObject
{
    @private NSMutableArray      *_persons;
    
    @private ServerConnectorCallback *serverCallback;
}

- (NSData *)sendDataRequest;
- (void)populatePersons;
- (void)populateEmails;
@end
