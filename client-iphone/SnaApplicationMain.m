
#import <UIKit/UIKit.h>
#import "ServerConnector.h"

int main(int argc, char *argv[])
{
    int retVal;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    {
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    [pool release];
    
    return retVal;
}
