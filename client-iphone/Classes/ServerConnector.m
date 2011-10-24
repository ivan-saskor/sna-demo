#import "ServerConnector.h"
#import "ServerConnectorCallback.h"

@implementation ServerConnector

- (id)init
{
    self = [super init];
    if (self) {
        serverCallback = [[ServerConnectorCallback alloc] init];

    }
    
    return self;
}

- (NSData *)sendDataRequest
{
    NSMutableURLRequest *dataRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/api/data"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *dataConnection=[[NSURLConnection alloc] initWithRequest:dataRequest delegate:serverCallback];
    [dataRequest addValue:@"x" forHTTPHeaderField: @"EMAIL"];
    [dataRequest addValue:@"y" forHTTPHeaderField: @"PASSWORD"];
    

    if (dataConnection)
    {
        NSData * receivedData = [NSURLConnection sendSynchronousRequest:dataRequest returningResponse:nil error:nil];
        
        NSLog(@"request sent");
        return receivedData;
    }
    
    @throw ([NSException exceptionWithName:@"no good" reason:@"no reason as well" userInfo:nil]);
}

@end
