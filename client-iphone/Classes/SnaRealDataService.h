
#import "_Fx.h"
#import "_Domain.h"

#import "SnaDataService.h"
#import "ServerConnector.h"
#import "SnaHttpDataRepository.h"

#import <CoreLocation/CoreLocation.h>

@interface SnaRealDataService : NSObject <SnaIDataService, CLLocationManagerDelegate>
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
	
    @private SnaLocation            *_gpsLocation;
	@private SnaLocation            *_currentLocation;
	@private NSArray                *_availableLocations;
    
    @private SnaTargetingRange      *_targetingRange;
    @private NSArray                *_availableTargetingRanges;
	
	@private ServerConnector        *_connector;
    @private SnaHttpDataRepository  *_dataRepository;
    
    @private NSOperationQueue       *_queue;
    @private NSTimer                *_timer;
    @private CLLocationManager      *_locationManager;
    
	#ifdef DEBUG
		
	@private SnaPerson           *_personA;
	@private SnaPerson           *_personB;
		
	#endif
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
@end
