#import "ServerConnector.h"
#import "ServerConnectorCallback.h"
#import "CJSONDeserializer.h"

@implementation ServerConnector

- (id)init
{
    self = [super init];
    if (self) {
        serverCallback = [[ServerConnectorCallback alloc] init];

        _persons = [[NSMutableArray alloc] init];
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

- (void)populatePersons
{
    NSData * data = [self sendDataRequest];
    
    NSError *theError = nil;
    
    NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[[CJSONDeserializer deserializer] deserialize:data error:&theError]];
    
    if (theError == nil) 
    {
        NSLog(@"no error loading json");
        
        //			id *emails = [theObject objectForKey:@"NearbyPersonsEmails"];
        NSArray *emails = [theObject mutableArrayValueForKey:@"NearbyPersonsEmails"];
        
        
        for (int i=0; i<[emails count]; i++)
        {                           
            NSLog(@"%@", [emails objectAtIndex:i]);
        }
        
        //			NSArray *allKeys = [emails allKeys];
        //			
        
        //NSLog(@"%s", emails);		
    }
    else
    {
        @throw ([NSException exceptionWithName:@"parse error" reason:@"can't parse json" userInfo:nil]);
    }

}

- (void)populateEmails
{
    NSData * data = [self sendDataRequest];
    
    //NSDictionary *theObject = [NSDictionary dictionaryWithDictionary:[[CJSONDeserializer deserializer] deserialize:data error:&theError]];
    
    
}

@end
