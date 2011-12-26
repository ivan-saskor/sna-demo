
#import <UIKit/UIKit.h>
#import "ServerConnector.h"

int main(int argc, char *argv[])
{
    int retVal;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    {
        NSData * data;
        ServerConnector * connector = [[ServerConnector alloc] initWithUrlPrefix:@"http://localhost:3000"];
        //ServerConnector * connector = [[ServerConnector alloc] initWithUrlPrefix:@"http://baltazar.fesb.hr/~lana/bvisible"];
        //[connector sendDataRequestForEmail:@"perisal@fesb.hr" withPassword:@"lana"];
        
        //SnaPerson *person1 = [connector FindPersonByEmail:@"x"];
        //SnaPerson *person2 = [connector FindPersonByEmail:@"b-email"];
        
        //SnaMessage *message = [connector FindMessageById:@"15"];
        
        //[connector sendFriendshipRequestFrom:person1 to:person2 withMessage:@"Be my friend"];
        //[connector rejectFriendshipFor:person2 to:person1];
        //[connector sendFriendshipRequestFrom:person2 to:person1 withMessage:@"I accepted you"];
        //[connector sendMessageFrom:person1 to:person2 withText:@"WELL HELLOOOOO!"];

        //[connector markMessage:message asReadForPerson:person2];
        
        //NSLog(@"Json: %@", [connector testJson]);
        
        //SnaMutablePerson *newPerson = [[SnaMutablePerson alloc] initWithEmail:@"Test2" password:@"Test" visibilityStatus:[SnaVisibilityStatus ONLINE] offlineSince:[NSDate date]  friendshipStatus:nil rejectedOn:nil nick:@"Test" mood:@"" gravatarCode:@"" bornOn:nil gender:[SnaGender MALE] lookingForGenders:nil phone:@"" myDescription:@"" occupation:@"" hobby:@"" mainLocation:@"" lastKnownLocation:nil distanceInMeeters:0];
        
        //[connector createProfileForPerson:newPerson];
        //[connector updateProfileForPerson:newPerson];
        
        //[connector ];
        
        retVal = UIApplicationMain(argc, argv, nil, nil);
    }
    [pool release];
    
    return retVal;
}
