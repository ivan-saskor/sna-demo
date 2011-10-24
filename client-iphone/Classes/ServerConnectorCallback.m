#import "ServerConnectorCallback.h"

@implementation ServerConnectorCallback
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
	
    //[receivedData setLength:0];	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.	
    // receivedData is an instance variable declared elsewhere.
	
    //[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
	
    [connection release];
	
    // receivedData is declared as a method instance elsewhere
	
    //[receivedData release];
	
    // inform the user
	
    NSLog(@"Connection failed! Error - %@ %@",
		  
          [error localizedDescription],
		  
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data	
    // receivedData is declared as a method instance elsewhere
	
    //NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    // release the connection, and the data object
	
    //[connection release];	
    //[receivedData release];
}
@end
