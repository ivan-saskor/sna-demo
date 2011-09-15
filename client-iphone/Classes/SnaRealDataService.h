
#import "_Fx.h"
#import "_Domain.h"

#import "SnaDataService.h"

@interface SnaRealDataService : NSObject <SnaIDataService>
{
	@private NSMutableArray      *_persons;
	@private NSMutableArray      *_messages;
		
	@private NSMutableDictionary *_friendshipRelations;
	@private NSMutableDictionary *_friendshipRequests;
	@private NSMutableDictionary *_rejections;
		
	@private NSString            *_defaultLogInEmail;
	@private NSString            *_defaultLogInPassword;
		
	@private SnaMutablePerson    *_currentUser;
		
	@private NSMutableArray      *_nearbyPersons;
	@private NSMutableArray      *_friends;
	@private NSMutableArray      *_waitingForMePersons;
	@private NSMutableArray      *_waitingForHimPersons;
	@private NSMutableArray      *_rejectedPersons;
		
	@private NSMutableArray      *_friendsWithMessages;
		
	@private SnaLocation         *_currentLocation;
	@private NSArray             *_availableLocations;
		
	#ifdef DEBUG
		
	@private SnaPerson           *_personA;
	@private SnaPerson           *_personB;
		
	#endif
}

@end
