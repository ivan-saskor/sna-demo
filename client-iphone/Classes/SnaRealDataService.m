
#import "_Services.h"

@interface SnaRealDataService() 

@property (nonatomic, assign, readwrite) NSInteger    timestamp;

@property (nonatomic,   copy, readwrite) NSString    *defaultLogInEmail;
@property (nonatomic,   copy, readwrite) NSString    *defaultLogInPassword;

@property (nonatomic, retain, readwrite) SnaPerson   *currentUser;

@property (nonatomic, retain, readwrite) SnaLocation *currentLocation;

@property (nonatomic, retain, readwrite) SnaTargetingRange *targetingRange;

@property (nonatomic, assign, readwrite) NSInteger    unreadMessagesCount;
@property (nonatomic, assign, readwrite) NSInteger    incommingRequestsCount;

- (void) _fillTestData;

- (void) _refreshData;

- (SnaPerson  *) _registerPersonWithString :(NSString *)string;

- (SnaPerson *)  _registerPersonWithEmail  :(NSString *)email
                                   password:(NSString *)password
                                       nick:(NSString *)nick
                                       mood:(NSString *)mood
                                     bornOn:(NSDate *)bornOn
                                     gender:(SnaGender *)gender
                          lookingForGenders:(NSSet *)lookingForGenders
                              myDescription:(NSString *)myDescription
                                 occupation:(NSString *)occupation
                                      hobby:(NSString *)hobby
                               mainLocation:(NSString *)mainLocation
                                      phone:(NSString *)phone;

- (SnaMessage *) _registerMessageWithString:(NSString *)string from:(SnaPerson *)personA to:(SnaPerson *)personB;

- (void) _registerAsFriendsPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB;
- (void) _unregisterFriendsPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB;
- (BOOL) _areFriendsPerson       :(SnaPerson *)personA andPerson:(SnaPerson *)personB;

- (void) _registerFriendshipRequestFromPerson  :(SnaPerson *)personA toPerson:(SnaPerson *)personB;
- (void) _unregisterFriendshipRequestFromPerson:(SnaPerson *)personA toPerson:(SnaPerson *)personB;
- (BOOL) _existsFriendshipRequestFromPerson    :(SnaPerson *)personA toPerson:(SnaPerson *)personB;

- (void) _registerAsRejectedPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB;
- (void) _unregisterRejectedPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB;
- (BOOL) _areRejectedPerson       :(SnaPerson *)personA andPerson:(SnaPerson *)personB;

- (BOOL) _areInRelationPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB;

- (SnaPerson *) _tryFindPersonWithEmail:(NSString *)email password:(NSString *)password;

- (BOOL) _existsPersonWithEmail:(NSString *)email;
- (BOOL) _existsPersonWithNick :(NSString *)nick;

- (void) _logInPerson:(SnaPerson *)person;

- (void) _allignData;

//- (void) _allignPersons_relationshipStatuses;
- (void) _allignPersons_messagess;
- (void) _allignPersons_refreshCalculatedFields_CHAMPION;

- (void) _allignNearbyPersons;
- (void) _allignFriends;
- (void) _allignWaitingForMePersons;
- (void) _allignWaitingForHimPersons;
- (void) _allignRejectedPersons;

- (void) _allignFriendsWithMessages;

- (void) _allignUnreadCounts;

- (NSArray *) _findMessagesWithPerson:(SnaPerson *)person;

- (NSArray *) _findNearbyPersons;
- (NSArray *) _findFriends;
- (NSArray *) _findWaitingForMePersons;
- (NSArray *) _findWaitingForHimPersons;
- (NSArray *) _findRejectedPersons;

- (NSArray *) _findFriendsWithMessages;

@end
@implementation SnaRealDataService

@synthesize timestamp            = _timestamp;

@synthesize defaultLogInEmail    = _defaultLogInEmail;
@synthesize defaultLogInPassword = _defaultLogInPassword;

@synthesize currentUser          = _currentUser; //needed

@synthesize nearbyPersons        = _nearbyPersons;
@synthesize friends              = _friends;
@synthesize waitingForMePersons  = _waitingForMePersons;
@synthesize waitingForHimPersons = _waitingForHimPersons;
@synthesize rejectedPersons      = _rejectedPersons;

@synthesize friendsWithMessages  = _friendsWithMessages;

@synthesize currentLocation      = _currentLocation;
@synthesize availableLocations   = _availableLocations;

@synthesize targetingRange      = _targetingRange;
@synthesize availableTargetingRanges   = _availableTargetingRanges;

@synthesize unreadMessagesCount    = _unreadMessagesCount;
@synthesize incommingRequestsCount = _incommingRequestsCount;

- (id) init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
	
    _timestamp            = 0;
    
    _persons              = [[NSMutableArray      alloc] init];
    _messages             = [[NSMutableArray      alloc] init];
	
    _friendshipRelations  = [[NSMutableDictionary alloc] init];
    _friendshipRequests   = [[NSMutableDictionary alloc] init];
    _rejections           = [[NSMutableDictionary alloc] init];
    
    _defaultLogInEmail    = [@"" copy];
    _defaultLogInPassword = [@"" copy];
    
    _currentUser          = nil;
    
    _nearbyPersons        = [[NSMutableArray alloc] init];
    _friends              = [[NSMutableArray alloc] init];
    _waitingForMePersons  = [[NSMutableArray alloc] init];
    _waitingForHimPersons = [[NSMutableArray alloc] init];
    _rejectedPersons      = [[NSMutableArray alloc] init];
    
    _friendsWithMessages  = [[NSMutableArray alloc] init];
	
    _gpsLocation = [[SnaMutableLocation alloc] initWithName:@"GPS Location" latitude:0 longitude:0];
    
    _availableLocations   = [[NSArray alloc] initWithObjects:
        _gpsLocation,
		[[SnaImmutableLocation alloc] initWithName:@"Bucharest" latitude:1 longitude:1],
		[[SnaImmutableLocation alloc] initWithName:@"Prague"    latitude:2 longitude:2],
		[[SnaImmutableLocation alloc] initWithName:@"London"    latitude:3 longitude:3],
        [[SnaImmutableLocation alloc] initWithName:@"Zagreb"    latitude:4 longitude:4],
		nil
	];
    
    _availableTargetingRanges   = [[NSArray alloc] initWithObjects:
							 
                             [[SnaImmutableTargetingRange alloc] initWithRadiusInMeters:100],
                             [[SnaImmutableTargetingRange alloc] initWithRadiusInMeters:500],
                             [[SnaImmutableTargetingRange alloc] initWithRadiusInMeters:3000],
                             [[SnaImmutableTargetingRange alloc] initWithRadiusInMeters:10000],
                             nil
                             ];
    
    _targetingRange = [_availableTargetingRanges objectAtIndex:2];
    
    _unreadMessagesCount    = 0;
    _incommingRequestsCount = 0;
	
	NSLog(@"Inicijalizacija");
	
	//_connector = [[[ServerConnector alloc] initWithUrlPrefix:@"http://localhost:3000"] retain];
    _connector = [[[ServerConnector alloc] initWithUrlPrefix:@"http://baltazar.fesb.hr/~lana/bvisible"] retain];
    
    _dataRepository = [[[SnaHttpDataRepository alloc]initWithConnector:_connector] retain];
    
    _queue = [[NSOperationQueue alloc] init];
    [_queue setMaxConcurrentOperationCount:1];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 20; // triger delegate every 20 meters
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 10 m
    
	#if DEBUG
    {
        _personA = nil;
        _personB = nil;
    }
	#endif
    
    //[self _fillTestData];
    
    //[self _logInPerson:[_persons objectAtIndex:0]];
    
	
	self.currentLocation = [self.availableLocations objectAtIndex:0]; //gps
    
    return self;
}
- (void) dealloc
{
    [_persons              release];
    [_messages             release];
	
    [_friendshipRelations  release];
    [_friendshipRequests   release];
    [_rejections           release];
    
    [_defaultLogInEmail    release];
    [_defaultLogInPassword release];
    
    [_currentUser          release];
	
    [_nearbyPersons        release];
    [_friends              release];
    [_waitingForMePersons  release];
    [_waitingForHimPersons release];
    [_rejectedPersons      release];
    [_friendsWithMessages  release];
    
    [_availableLocations   release];
    [_currentLocation      release];
    
    [_availableTargetingRanges release];
    [_targetingRange       release];
    
    [_connector release];
    [_dataRepository release];
    
    [_queue release];
    [_timer invalidate];
    [_locationManager release];
	#if DEBUG
    {
        [_personA          release];
        [_personB          release];
    }
	#endif
    
	[super dealloc];
}


- (void) _refreshData
{
    [_persons replaceObjectsInRange:NSMakeRange(0, [_persons count]) withObjectsFromArray:[_connector getPersons]];
    [_messages replaceObjectsInRange:NSMakeRange(0, [_messages count]) withObjectsFromArray:[_connector getMessages]];
}

- (BOOL) getDataWithEmail :(NSString *)email password:(NSString *)password
{
    if ([_connector sendDataRequestForEmail:email withPassword:password]) {
        [self _refreshData];
        
        return YES;
    }
    return NO;
}

- (BOOL) tryLogInWithEmail :(NSString *)email password:(NSString *)password
{
    [FxAssert isNotNullArgument:email    withName:@"email"   ];
    [FxAssert isNotNullArgument:password withName:@"password"];
	
    [FxAssert isValidState:(self.currentUser == nil) reason:@"User is already logged in"];
	
    
    if ([email isEqual:@""] || [password isEqual:@""])
    {
        return NO;
    }
	
	[self getDataWithEmail:email password:password];
    
    [self _allignData];
	
	SnaPerson *person = [self _tryFindPersonWithEmail:email password:password];
	
    if (person == nil)
    {
        return NO;
    }
	
    [self _logInPerson:person];
    
    return YES;
}

- (BOOL) trySignUpWithEmail:(NSString *)email
                   password:(NSString *)password
                       nick:(NSString *)nick
                       mood:(NSString *)mood
                     bornOn:(NSDate *)bornOn
                     gender:(SnaGender *)gender
          lookingForGenders:(NSSet *)lookingForGenders
              myDescription:(NSString *)myDescription
                 occupation:(NSString *)occupation
                      hobby:(NSString *)hobby
               mainLocation:(NSString *)mainLocation
                      phone:(NSString *)phone
{
    [FxAssert isNotNullArgument:email    withName:@"email"   ];
    [FxAssert isNotNullArgument:password withName:@"password"];
    [FxAssert isNotNullArgument:nick     withName:@"nick"    ];
    
    if ([email isEqual:@""] || [password isEqual:@""] || [nick isEqual:@""])
    {
        return NO;
    }
	
    [FxAssert isValidState:(self.currentUser == nil) reason:@"User is already logged in"];
    
    if ([self _existsPersonWithEmail:email] || [self _existsPersonWithNick:nick])
    {
        return NO;
    }
	
    SnaPerson *person = [self _registerPersonWithEmail:email password:password nick:nick mood:mood bornOn:bornOn gender:gender lookingForGenders:lookingForGenders myDescription:myDescription occupation:occupation hobby:hobby mainLocation:mainLocation phone:phone];
    
    if (person != nil)
    {
        [self _logInPerson:person];
        return YES;
    }
    
    return NO;
}

- (void) logOut
{
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
	
    [_timer invalidate];
    
    [_locationManager stopUpdatingLocation];
    
    self.currentUser = nil;
 
    [_connector resetData];
    
    [self _allignData];
}

- (void) requestFriendshipToQueue:(NSDictionary *) methodData
{
    [FxAssert isNotNullArgument:methodData withName:@"methodData"];
    
    SnaPerson *person  = [methodData objectForKey:@"person"];
    NSString  *message = [methodData objectForKey:@"message"];
    
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
	
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus    ALIEN]
							|| person.friendshipStatus == [SnaFriendshipStatus REJECTED]) reason:@"Invalid person status"];
    
    [_connector sendFriendshipRequestFrom:[self currentUser] to:person withMessage:message];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}
- (void) requestFriendshipToPerson:(SnaPerson *)person withMessage:(NSString *)message
{
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:person, @"person", message, @"message" , nil];
    [self requestFriendshipToQueue:dataDictionary];
//    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(requestFriendshipToQueue:) object:dataDictionary] autorelease];
//    [_queue addOperation:operation];
}

- (void) acceptFriendshipToQueue:(NSDictionary *) methodData
{
    [FxAssert isNotNullArgument:methodData withName:@"methodData"];
    
    SnaPerson *person  = [methodData objectForKey:@"person"];
    NSString  *message = [methodData objectForKey:@"message"];
    
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME]) reason:@"Invalid person status"];
    
	[_connector sendFriendshipRequestFrom:[self currentUser] to:person withMessage:message];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}
- (void) acceptFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:person, @"person", message, @"message" , nil];
    [self acceptFriendshipToQueue:dataDictionary];
//    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(acceptFriendshipToQueue:) object:dataDictionary] autorelease];
//    [_queue addOperation:operation];
}

- (void) rejectFriendshipToQueue:(NSDictionary *) methodData
{
    [FxAssert isNotNullArgument:methodData  withName:@"methodData"];
    
    SnaPerson *person  = [methodData objectForKey:@"person"];
    NSString  *message = [methodData objectForKey:@"message"];
    
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME]) reason:@"Invalid person status"];
    
    [_connector rejectFriendshipFor:[self currentUser] to:person withMessage:message];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}
- (void) rejectFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:person, @"person", message, @"message" , nil];
    [self rejectFriendshipToQueue:dataDictionary];
//    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(rejectFriendshipToQueue:) object:dataDictionary] autorelease];
//    [_queue addOperation:operation];
}

- (void) cancelFriendshipToQueue:(NSDictionary *) methodData
{
    [FxAssert isNotNullArgument:methodData  withName:@"methodData"];
    
    SnaPerson *person =  [methodData objectForKey:@"person"];
    NSString  *message = [methodData objectForKey:@"message"];
    
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
	
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus FRIEND]) reason:@"Invalid person status"];
    
    [_connector rejectFriendshipFor:[self currentUser] to:person withMessage:message];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}
- (void) cancelFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:person, @"person", message, @"message" , nil];
    [self cancelFriendshipToQueue:dataDictionary];
//    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(cancelFriendshipToQueue:) object:dataDictionary] autorelease];
//    [_queue addOperation:operation];
}

- (void) callPerson               :(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus FRIEND]) reason:@"Invalid person status"];
	
    [[[[UIAlertView alloc] initWithTitle:person.nick message:@"Calling mobile" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil] autorelease] show];
    
    //
    // http://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/PhoneLinks.html
    //
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [person phone]]]];
    //
}

- (void)changeMoodInQueue:(NSString *)mood
{
    [FxAssert isNotNullArgument:mood withName:@"mood"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
	
    ((SnaMutablePerson *)self.currentUser).mood = mood;
    
    [_connector updateProfileForPerson:[self currentUser]];
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}

- (void) changeMood:(NSString *)mood
{
    NSInvocationOperation * operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(changeMoodInQueue:) object:mood] autorelease];
    [_queue addOperation:operation];
}


- (void) changeLocationInQueue:(SnaLocation *)location
{
    [FxAssert isNotNullArgument:location withName:@"location"];
    [FxAssert isValidArgument  :location withName:@"location" validation:[_availableLocations containsObject:location]];
	
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
	
    self.currentLocation = location;
    
    [_connector updateProfileForPerson:[self currentUser] withLocation:location];
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}
- (void) changeLocation:(SnaLocation *)location
{
    [self changeLocationInQueue:location];
//    NSInvocationOperation * operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(changeLocationInQueue:) object:location] autorelease];
//    [_queue addOperation:operation];
}

- (void) changeTargetingRange:(SnaTargetingRange *) targetingRange
{
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    self.targetingRange = targetingRange;
    
    [self _allignData];
}

- (void) sendMessageInQueue:(NSDictionary *)methodData{
    [FxAssert isNotNullArgument        :methodData  withName:@"methodData"];
    
    NSString *text =      [methodData objectForKey:@"text"];
    SnaPerson *toPerson = [methodData objectForKey:@"toPerson"];
    
    [FxAssert isNotNullNorEmptyArgument:text   withName:@"text"];
    [FxAssert isNotNullArgument        :toPerson withName:@"toPerson"];
    [FxAssert isValidArgument          :toPerson withName:@"toPerson" validation:[_persons containsObject:toPerson]];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [_connector sendMessageFrom:[self currentUser] to:toPerson withText:text];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];

}
- (void) sendMessageWithText:(NSString *)text toPerson:(SnaPerson *)toPerson
{
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:text, @"text", toPerson, @"toPerson", nil];
    NSInvocationOperation *operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(sendMessageInQueue:) object:dataDictionary] autorelease];
    [_queue addOperation:operation];
}

- (void) markAsReadAllMessagesFromPersonInQueue:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isValidArgument  :person withName:@"person" validation:person != self.currentUser];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    BOOL isRefreshNeeded = NO;
    
    for (SnaMessage *message in person.messages)
    {
        if (message.to == self.currentUser && !message.isRead)
        {
            NSLog(@"Message: %@ with ID %@", message.text, message.id);
            [_connector markMessage:message asReadForPerson:self.currentUser];
            
            isRefreshNeeded = YES;
        }
    }
    
    if (isRefreshNeeded)
    {
        [self _refreshData];
        [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
    }
}

- (void) markAsReadAllMessagesFromPerson:(SnaPerson *)person
{
    NSInvocationOperation * operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(markAsReadAllMessagesFromPersonInQueue:) object:person] autorelease];
    [_queue addOperation:operation];
}

- (void) _fillTestData
{
    SnaPerson *personA = [self _registerPersonWithString:@"a"];
    SnaPerson *personB = [self _registerPersonWithString:@"b"];
    
    SnaPerson *person0 = [self _registerPersonWithString:@"0"];
    SnaPerson *person1 = [self _registerPersonWithString:@"1"];
    SnaPerson *person2 = [self _registerPersonWithString:@"2"];
    SnaPerson *person3 = [self _registerPersonWithString:@"3"];
    SnaPerson *person4 = [self _registerPersonWithString:@"4"];
    
    [self _registerAsFriendsPerson:personA andPerson:person0];
    [self _registerAsFriendsPerson:personA andPerson:person1];
    [self _registerMessageWithString:@"friends-1" from:personA to:person0];
    [self _registerMessageWithString:@"friends-2" from:personA to:person1];
    
    [self _registerFriendshipRequestFromPerson:personA toPerson:person2];
    [self _registerFriendshipRequestFromPerson:person3 toPerson:personA];
    [self _registerMessageWithString:@"request-1" from:personA to:person2];
    [self _registerMessageWithString:@"request-2" from:person3 to:personA];
	
    [self _registerAsRejectedPerson:personA andPerson:person4];
    [self _registerMessageWithString:@"rejected-2" from:personA to:person4];
	
    [self _registerMessageWithString:@"m-1" from:personA to:person0];
    [self _registerMessageWithString:@"m-2" from:personA to:person3];
    [self _registerMessageWithString:@"m-3" from:person2 to:personA];
    [self _registerMessageWithString:@"m-4" from:person0 to:personA];
    [self _registerMessageWithString:@"m-5" from:person3 to:personA];
    [self _registerMessageWithString:@"m-6" from:person3 to:personA];
    [self _registerMessageWithString:@"m-7" from:personA to:person3];
    [self _registerMessageWithString:@"m-8" from:person3 to:person2];
    [self _registerMessageWithString:@"m-9" from:person3 to:personA];
    
    [self _allignData];
	
#if DEBUG
    {
        _personA = [personA retain];
        _personB = [personB retain];
    }
#endif
    
    personA = personB = person0 = person1 = person2 = person3 = person4 = nil; // Dummy code to avoid unused variable warning
}

- (SnaPerson *)  _registerPersonWithString:(NSString *)string
{
    //TODO - vidit sta ce nam ovo uopce
    [FxAssert isNotNullNorEmptyArgument:string withName:@"string"];
	
    [FxAssert isValidArgument:string withName:@"string" validation:![self _existsPersonWithEmail:string]];
    [FxAssert isValidArgument:string withName:@"string" validation:![self _existsPersonWithNick :string]];
    
    SnaPerson *person = [[[SnaMutablePerson alloc] initWithEmail:string
                                                        password:string
						  
                                                visibilityStatus:[SnaVisibilityStatus OFFLINE]
                                                    offlineSince:[NSDate date]
						  
                                                friendshipStatus:[SnaFriendshipStatus SELF]
                                                      rejectedOn:nil
						  
                                                            nick:string
                                                            mood:@""
                                                    gravatarCode:nil
						  
                                                          bornOn:nil
                                                          gender:nil
                                               lookingForGenders:[NSSet set]
						  
                                                           phone:@""
                                                   myDescription:@""
                                                      occupation:@""
                                                           hobby:@""
                                                    mainLocation:@""
                          
                                               lastKnownLocation:nil
                                               distanceInMeeters:0] autorelease];
    
    [_persons addObject:person];
    
    return person;
}

- (SnaPerson *)  _registerPersonWithEmail:(NSString *)email
                                 password:(NSString *)password
                                     nick:(NSString *)nick
                                     mood:(NSString *)mood
                                   bornOn:(NSDate *)bornOn
                                   gender:(SnaGender *)gender
                        lookingForGenders:(NSSet *)lookingForGenders
                            myDescription:(NSString *)myDescription
                               occupation:(NSString *)occupation
                                    hobby:(NSString *)hobby
                             mainLocation:(NSString *)mainLocation
                                    phone:(NSString *)phone
{
    [FxAssert isNotNullNorEmptyArgument:email    withName:@"email"   ];
    [FxAssert isNotNullNorEmptyArgument:password withName:@"password"];
    [FxAssert isNotNullNorEmptyArgument:nick     withName:@"nick"    ];
    
    SnaPerson *person = [[[SnaMutablePerson alloc] initWithEmail:email
                                                        password:password
                          
                                                visibilityStatus:[SnaVisibilityStatus ONLINE]
                                                    offlineSince:nil
                          
                                                friendshipStatus:[SnaFriendshipStatus SELF]
                                                      rejectedOn:nil
                          
                                                            nick:nick
                                                            mood:mood
                                                    gravatarCode:nil
                          
                                                          bornOn:bornOn
                                                          gender:gender
                                               lookingForGenders:lookingForGenders
                          
                                                           phone:phone
                                                   myDescription:myDescription
                                                      occupation:occupation
                                                           hobby:hobby
                                                    mainLocation:mainLocation
                          
                                               lastKnownLocation:nil
                                               distanceInMeeters:0] autorelease];
    
    if([_connector createProfileForPerson:person])
    {
        //[_persons addObject:person];
        
        [self getDataWithEmail:[person email] password:[person password]];
        
        return [self _tryFindPersonWithEmail:[person email] password:[person password]];
    }

    return nil;
}
- (SnaMessage *) _registerMessageWithString:(NSString *)string from:(SnaPerson *)personA to:(SnaPerson *)personB;
{
    [FxAssert isNotNullNorEmptyArgument:string  withName:@"string"];
    [FxAssert isNotNullArgument        :personA withName:@"personA"];
    [FxAssert isValidArgument          :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument        :personB withName:@"personB"];
    [FxAssert isValidArgument          :personB withName:@"personB" validation:[_persons containsObject:personB]];
	
    SnaMessage *message = [[[SnaMutableMessage alloc] initWithId:string
                                                            from:personA
                                                              to:personB
                                                            text:string
                                                          sentOn:[NSDate date]
                                                          readOn:nil] autorelease];
    
    [_connector sendMessageFrom:personA to:personB withText:string];
    [self getDataWithEmail:[_currentUser email] password:[_currentUser password]];
    [self _allignData];
    
    //[_messages addObject:message];
    
    return message;
}

- (void) _registerAsFriendsPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
	
    [FxAssert isValidState:(![self _areInRelationPerson:personA andPerson:personB]) reason:@"Persons are already in relation"];
    
    if ([_friendshipRelations objectForKey:personA.email] == nil)
    {
        [_friendshipRelations setValue:[[NSMutableArray alloc] init] forKey:personA.email];
    }
    
    NSMutableArray *friendsOfA = (NSMutableArray *)[_friendshipRelations objectForKey:personA.email];
    {
        [friendsOfA addObject:personB.email];
    }
}
- (void) _unregisterFriendsPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    [FxAssert isValidState:([self _areFriendsPerson:personA andPerson:personB]) reason:@"Persons are not friends"];
	
    NSMutableArray *friendsOfA = (NSMutableArray *)[_friendshipRelations objectForKey:personA.email];
    {
        [friendsOfA removeObject:personB.email];
    }
	
    NSMutableArray *friendsOfB = (NSMutableArray *)[_friendshipRelations objectForKey:personB.email];
    {
        [friendsOfB removeObject:personA.email];
    }
}
- (BOOL) _areFriendsPerson       :(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    NSMutableArray *friendsOfA = (NSMutableArray *)[_friendshipRelations objectForKey:personA.email];
    NSMutableArray *friendsOfB = (NSMutableArray *)[_friendshipRelations objectForKey:personB.email];
    
    return (friendsOfA != nil && [friendsOfA containsObject:personB.email])
	|| (friendsOfB != nil && [friendsOfB containsObject:personA.email]);
}

- (void) _registerFriendshipRequestFromPerson  :(SnaPerson *)personA toPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    [FxAssert isValidState:(![self _areInRelationPerson:personA andPerson:personB]) reason:@"Persons are already in relation"];
    
    if ([_friendshipRequests objectForKey:personA.email] == nil)
    {
        [_friendshipRequests setValue:[[NSMutableArray alloc] init] forKey:personA.email];
    }
    
    NSMutableArray *friendshipRequestsOfA = (NSMutableArray *)[_friendshipRequests objectForKey:personA.email];
    {
        [friendshipRequestsOfA addObject:personB.email];
    }
}
- (void) _unregisterFriendshipRequestFromPerson:(SnaPerson *)personA toPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    [FxAssert isValidState:([self _existsFriendshipRequestFromPerson:personA toPerson:personB]) reason:@"Friendship request does not exist"];
    
    NSMutableArray *friendshipRequestsOfA = (NSMutableArray *)[_friendshipRequests objectForKey:personA.email];
    {
        [friendshipRequestsOfA removeObject:personB.email];
    }
}
- (BOOL) _existsFriendshipRequestFromPerson    :(SnaPerson *)personA toPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    NSMutableArray *friendshipRequestsOfA = (NSMutableArray *)[_friendshipRequests objectForKey:personA.email];
    
    return friendshipRequestsOfA != nil && [friendshipRequestsOfA containsObject:personB.email];
}

- (void) _registerAsRejectedPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    [FxAssert isValidState:(![self _areInRelationPerson:personA andPerson:personB]) reason:@"Persons are already in relation"];
    
    if ([_rejections objectForKey:personA.email] == nil)
    {
        [_rejections setValue:[[NSMutableArray alloc] init] forKey:personA.email];
    }
    
    NSMutableArray *rejectionsOfA = (NSMutableArray *)[_rejections objectForKey:personA.email];
    {
        [rejectionsOfA addObject:personB.email];
    }
}
- (void) _unregisterRejectedPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    [FxAssert isValidState:([self _areRejectedPerson:personA andPerson:personB]) reason:@"Persons are not rejected"];
    
    NSMutableArray *rejectionsOfA = (NSMutableArray *)[_rejections objectForKey:personA.email];
    {
        [rejectionsOfA removeObject:personB.email];
    }
	
    NSMutableArray *rejectionsOfB = (NSMutableArray *)[_rejections objectForKey:personB.email];
    {
        [rejectionsOfB removeObject:personA.email];
    }
}
- (BOOL) _areRejectedPerson       :(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    NSMutableArray *rejectionsOfA = (NSMutableArray *)[_rejections objectForKey:personA.email];
    NSMutableArray *rejectionsOfB = (NSMutableArray *)[_rejections objectForKey:personB.email];
    
    return (rejectionsOfA != nil && [rejectionsOfA containsObject:personB.email])
	|| (rejectionsOfB != nil && [rejectionsOfB containsObject:personA.email]);
}

- (BOOL) _areInRelationPerson:(SnaPerson *)personA andPerson:(SnaPerson *)personB
{
    [FxAssert isNotNullArgument:personA withName:@"personA"];
    [FxAssert isValidArgument  :personA withName:@"personA" validation:[_persons containsObject:personA]];
    [FxAssert isNotNullArgument:personB withName:@"personB"];
    [FxAssert isValidArgument  :personB withName:@"personB" validation:[_persons containsObject:personB]];
    
    return [self _areFriendsPerson                 :personA andPerson:personB]
	|| [self _existsFriendshipRequestFromPerson:personA  toPerson:personB]
	|| [self _existsFriendshipRequestFromPerson:personB  toPerson:personA]
	|| [self _areRejectedPerson                :personA andPerson:personB];
}

- (SnaPerson *) _tryFindPersonWithEmail:(NSString *)email password:(NSString *)password
{
    [FxAssert isNotNullNorEmptyArgument:email    withName:@"email"   ];
    [FxAssert isNotNullNorEmptyArgument:password withName:@"password"];
    
    for (SnaPerson *person in _persons)
    {
        if ([person.email isEqual:email] && [person.password isEqual:password])
        {
            return person;
        }
    }
    
    return nil;
}

- (BOOL) _existsPersonWithEmail:(NSString *)email
{
    [FxAssert isNotNullNorEmptyArgument:email withName:@"email"];
    
    for (SnaPerson *person in _persons)
    {
        if ([person.email isEqual:email])
        {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL) _existsPersonWithNick :(NSString *)nick
{
    [FxAssert isNotNullNorEmptyArgument:nick withName:@"nick"];
    
    for (SnaPerson *person in _persons)
    {
        if ([person.nick isEqual:nick])
        {
            return YES;
        }
    }
    return NO;
}

- (void)updateLocationInQueue:(SnaLocation *)location
{
    [FxAssert isNotNullArgument:location withName:@"location"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
	
    //((SnaMutablePerson *)self.currentUser).lastKnownLocation = location;
    
    [_connector updateProfileForPerson:[self currentUser] withLocation:location];
    
    [self _refreshData];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}

- (void) updateLocation:(SnaLocation *)location
{
    NSInvocationOperation * operation = [[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(updateLocationInQueue:) object:location] autorelease];
    [_queue addOperation:operation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    SnaLocation *location = [[[SnaImmutableLocation alloc] initWithName:@"Custom" latitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude] autorelease];

    [self updateLocation:location];
    NSLog(@"CURRENT POSITION: LAT: %.4f, LNG: %.4f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void) _logInPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
    
    [FxAssert isValidState:(self.currentUser == nil) reason:@"User is already logged in"];
	
    self.currentUser = person;
    
    [self _allignData];
    
   _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(reloadUserDataInQueue) userInfo:nil repeats:YES];
    
    [_locationManager startUpdatingLocation];

}
- (void)reloadUserDataInQueue{

    NSInvocationOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(reloadUserData) object:nil] autorelease];
    
    [_queue addOperation:operation];
}

- (void)reloadUserData{
    [self getDataWithEmail:self.currentUser.email password:self.currentUser.password];
    [self performSelectorOnMainThread:@selector(_allignData) withObject:nil waitUntilDone:YES];
}

- (void) _allignData
{
    [self _allignPersons_messagess                       ];
    [self _allignPersons_refreshCalculatedFields_CHAMPION];
    
    [self _allignNearbyPersons                           ];
    [self _allignFriends                                 ];
    [self _allignWaitingForMePersons                     ];
    [self _allignWaitingForHimPersons                    ];
    [self _allignRejectedPersons                         ];
    
    [self _allignFriendsWithMessages                     ];
    
    [self _allignUnreadCounts                            ];
    
    self.timestamp++;
}

- (void) _allignPersons_messagess
{
    for (SnaMutablePerson *person in _persons)
    {
        if (self.currentUser == nil || self.currentUser == person)
        {
            [person.messages removeAllObjects];
        }
        else
        {
            [person.messages replaceObjectsInRange:NSMakeRange(0, [person.messages count]) withObjectsFromArray:[self _findMessagesWithPerson:person]];
        }
    }
}
- (void) _allignPersons_refreshCalculatedFields_CHAMPION
{
    for (SnaMutablePerson *person in _persons)
    {
        [person refreshCalculatedFields_CHAMPION];
    }
}

- (void) _allignNearbyPersons
{
    if (self.currentUser == nil)
    {
        [_nearbyPersons removeAllObjects];
    }
    else
    {
        [_nearbyPersons replaceObjectsInRange:NSMakeRange(0, [_nearbyPersons count]) withObjectsFromArray:[self _findNearbyPersons]];
    }
}
- (void) _allignFriends
{
    if (self.currentUser == nil)
    {
        [_friends removeAllObjects];
    }
    else
    {
        [_friends replaceObjectsInRange:NSMakeRange(0, [_friends count]) withObjectsFromArray:[self _findFriends]];
    }
}
- (void) _allignWaitingForMePersons
{
    if (self.currentUser == nil)
    {
        [_waitingForMePersons removeAllObjects];
    }
    else
    {
        [_waitingForMePersons replaceObjectsInRange:NSMakeRange(0, [_waitingForMePersons count]) withObjectsFromArray:[self _findWaitingForMePersons]];
    }
}
- (void) _allignWaitingForHimPersons
{
    if (self.currentUser == nil)
    {
        [_waitingForHimPersons removeAllObjects];
    }
    else
    {
        [_waitingForHimPersons replaceObjectsInRange:NSMakeRange(0, [_waitingForHimPersons count]) withObjectsFromArray:[self _findWaitingForHimPersons]];
    }
}
- (void) _allignRejectedPersons
{
    if (self.currentUser == nil)
    {
        [_rejectedPersons removeAllObjects];
    }
    else
    {
        [_rejectedPersons replaceObjectsInRange:NSMakeRange(0, [_rejectedPersons count]) withObjectsFromArray:[self _findRejectedPersons]];
    }
}

- (void) _allignFriendsWithMessages
{
    if (self.currentUser == nil)
    {
        [_friendsWithMessages removeAllObjects];
    }
    else
    {
        [_friendsWithMessages replaceObjectsInRange:NSMakeRange(0, [_friendsWithMessages count]) withObjectsFromArray:[self _findFriendsWithMessages]];
    }
}

- (void) _allignUnreadCounts
{
    int unreadMessagesCount = 0;
    
    if (self.currentUser == nil)
    {
        self.unreadMessagesCount    = 0;
        self.incommingRequestsCount = 0;
    }
    else
    {
        for (SnaPerson *friend in self.friendsWithMessages)
        {
            for (SnaMessage *message in friend.messages)
            {
                if (message.to == self.currentUser && !message.isRead)
                {
                    unreadMessagesCount ++;
                }
            }
        }
        
        self.unreadMessagesCount = unreadMessagesCount;
        
        self.incommingRequestsCount = self.waitingForMePersons.count;
    }
}

- (NSArray *) _findMessagesWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
	
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaMessage *mesage in _messages)
    {
        if ((mesage.from == self.currentUser && mesage.to == person) || (mesage.from == person && mesage.to == self.currentUser))
        {
            [result addObject:mesage];
        }
    }
    
    return [result copy];
}

- (NSArray *) _findNearbyPersons
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaPerson *person in _persons)
    {
        if (person.distanceInMeeters <= _targetingRange.radiusInMeters)
        {
            [result addObject:person];
        }
    }
    
    [result removeObject:self.currentUser];
    
    return [result copy];
}
- (NSArray *) _findFriends
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaPerson *person in _persons)
    {
        if (person.friendshipStatus == [SnaFriendshipStatus FRIEND])
        {
            [result addObject:person];
        }
    }
    
    NSArray *sortedResult = [result sortedArrayUsingComparator:
                             
							 ^(id person1AsObject, id person2AsObject)
							 {
								 SnaPerson *person1 = (SnaPerson *)person1AsObject;
								 SnaPerson *person2 = (SnaPerson *)person2AsObject;
								 
								 return [person1.nick compare:person2.nick options:(NSCaseInsensitiveSearch | NSNumericSearch)];
							 }
							 ];
    
    return sortedResult;
}
- (NSArray *) _findWaitingForMePersons
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaPerson *person in _persons)
    {
        if (person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME])
        {
            [result addObject:person];
        }
    }
    
    NSArray *sortedResult = [result sortedArrayUsingComparator:
                             
							 ^(id person1AsObject, id person2AsObject)
							 {
								 SnaPerson *person1 = (SnaPerson *)person1AsObject;
								 SnaPerson *person2 = (SnaPerson *)person2AsObject;
								 
								 [FxAssert isNotNullValue:person1.lastMessage.sentOn];
								 [FxAssert isNotNullValue:person2.lastMessage.sentOn];
								 
								 return [person1.lastMessage.sentOn compare:person2.lastMessage.sentOn];
							 }
							 ];
    
    return [[sortedResult reverseObjectEnumerator] allObjects];
}
- (NSArray *) _findWaitingForHimPersons
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaPerson *person in _persons)
    {
        if (person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_HIM])
        {
            [result addObject:person];
        }
    }
    
    NSArray *sortedResult = [result sortedArrayUsingComparator:
                             
							 ^(id person1AsObject, id person2AsObject)
							 {
								 SnaPerson *person1 = (SnaPerson *)person1AsObject;
								 SnaPerson *person2 = (SnaPerson *)person2AsObject;
								 
								 [FxAssert isNotNullValue:person1.lastMessage.sentOn];
								 [FxAssert isNotNullValue:person2.lastMessage.sentOn];
								 
								 return [person1.lastMessage.sentOn compare:person2.lastMessage.sentOn];
							 }
							 ];
    
    return [[sortedResult reverseObjectEnumerator] allObjects];
}
- (NSArray *) _findRejectedPersons
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (SnaPerson *person in _persons)
    {
        if (person.friendshipStatus == [SnaFriendshipStatus REJECTED])
        {
            [result addObject:person];
        }
    }
    
    NSArray *sortedResult = [result sortedArrayUsingComparator:
                             
							 ^(id person1AsObject, id person2AsObject)
							 {
								 SnaPerson *person1 = (SnaPerson *)person1AsObject;
								 SnaPerson *person2 = (SnaPerson *)person2AsObject;
								 
								 [FxAssert isNotNullValue:person1.lastMessage.sentOn];
								 [FxAssert isNotNullValue:person2.lastMessage.sentOn];
								 
								 return [person1.lastMessage.sentOn compare:person2.lastMessage.sentOn];
							 }
							 ];
    
    return [[sortedResult reverseObjectEnumerator] allObjects];
}

- (NSArray *) _findFriendsWithMessages
{
    NSMutableArray *result = [NSMutableArray array];
	
    for (SnaPerson *friend in _friends)
    {
        if (friend.lastMessage != nil)
        {
            [result addObject:friend];
        }
    }
    
    NSArray *sortedResult = [result sortedArrayUsingComparator:
                             
							 ^(id person1AsObject, id person2AsObject)
							 {
								 SnaPerson *person1 = (SnaPerson *)person1AsObject;
								 SnaPerson *person2 = (SnaPerson *)person2AsObject;
								 
								 [FxAssert isNotNullValue:person1.lastMessage.sentOn];
								 [FxAssert isNotNullValue:person2.lastMessage.sentOn];
								 
								 return [person1.lastMessage.sentOn compare:person2.lastMessage.sentOn];
							 }
							 ];
    
    return [[sortedResult reverseObjectEnumerator] allObjects];
}













#ifdef DEBUG

- (void) testLogInPersonA
{
    [self _logInPerson:_personA];
}
- (void) testLogInPersonB
{
    [self _logInPerson:_personB];
}
- (void) testLogInRandomPerson
{
    [self _logInPerson:[self testGetRandomPerson]];
}

- (SnaPerson *) testGenerateNewProfile
{
    static int testIndex = 101;
	
    SnaMutablePerson *result = [[[SnaMutablePerson alloc] init] autorelease];
    {
        result.email    = [NSString stringWithFormat:@"New Profile Email %d"   , testIndex];
        result.password = [NSString stringWithFormat:@"New Profile Password %d", testIndex];
        result.nick     = [NSString stringWithFormat:@"New Profile Nick %d"    , testIndex];
    }
    
    return [result copy];
}

- (BOOL) testGetRandomBool
{
    int boolIndex = random() % 2;
    
    return boolIndex == 1;
}
- (SnaPerson *) testGetRandomPerson
{
    int personIndex = random() % _persons.count;
    
    return [_persons objectAtIndex:personIndex];
}
- (SnaPerson *) testGetRandomFriend
{
    [FxAssert isNotNullValue:self.currentUser];
    [FxAssert isValidState:[self.friends count] > 0];
    
    int friendIndex = random() % [self.friends count];
    
    return [self.friends objectAtIndex:friendIndex];
}

- (SnaVisibilityStatus *) testGetRandomVisibilityStatus
{
    int visibilityStatusIndex = 1 + random() % 2;
    
    return [[SnaVisibilityStatus values] objectAtIndex:visibilityStatusIndex];
}
- (NSDate *) testGetRandomBornOn
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
	
    int bornOnDayIndex = 15 * 265 + random() % 365 * 20;
	
    NSTimeInterval bornOnTimeinterval = - bornOnDayIndex * secondsPerDay;
	
    return [NSDate dateWithTimeIntervalSinceNow:bornOnTimeinterval];
}
- (SnaGender *) testGetRandomGender
{
    int genderIndex = random() % [[SnaGender values] count];
    
    return [[SnaGender values] objectAtIndex:genderIndex];
}
- (NSSet *) testGetRandomGenders
{
    NSMutableSet *result = [NSMutableSet set];
    
    for (SnaGender *gender in [SnaGender values])
    {
        if ([self testGetRandomBool])
        {
            [result addObject:gender];
        }
    }
    
    return [result copy];
}
- (NSInteger) testGetRandomDistance
{
    int distance = random() % 10000;
    
    return distance;
}

- (void) testAddFivePersons
{
    static int testIndex = 101;
    
    for (NSInteger i = 0; i < 5; i++)
    {
        SnaPerson *person = [self _registerPersonWithString:[NSString stringWithFormat:@"New Person %d", testIndex]];
        
        if (i == 0 && self.currentUser != nil)
        {
            [self _registerAsFriendsPerson:self.currentUser andPerson:person];
            [self _registerMessageWithString:@"new-friends" from:self.currentUser to:person];
        }
        if (i == 1 && self.currentUser != nil)
        {
            [self _registerFriendshipRequestFromPerson:person toPerson:self.currentUser];
            [self _registerMessageWithString:@"new-in-request" from:person to:self.currentUser];
        }
        if (i == 2 && self.currentUser != nil)
        {
            [self _registerFriendshipRequestFromPerson:self.currentUser toPerson:person];
            [self _registerMessageWithString:@"new-out-request" from:self.currentUser to:person];
        }
        if (i == 3 && self.currentUser != nil)
        {
            [self _registerAsRejectedPerson:self.currentUser andPerson:person];
            [self _registerMessageWithString:@"new-rejection" from:self.currentUser to:person];
        }
        
        testIndex ++;
    }
    
    [self _allignData];
}
- (void) testMutatePersons
{
    static int testIndex = 0;
    
    for (int i = 0; i < _persons.count; i++)
    {
        SnaMutablePerson *person = [_persons objectAtIndex:i];
        
        person.visibilityStatus   = [self testGetRandomVisibilityStatus];
        
        person.nick               = [NSString stringWithFormat:@"Nick %i - %i"         , i, testIndex];
        person.mood               = [NSString stringWithFormat:@"Mood %i - %i"         , i, testIndex];
        person.gravatarCode       = [NSString stringWithFormat:@"Gravatar Code %i - %i", i, testIndex];
        
        person.bornOn             = [self testGetRandomBornOn];
        person.gender             = [self testGetRandomGender];
        
        [person.lookingForGenders setSet:[self testGetRandomGenders]];
		
        person.phone              = [NSString stringWithFormat:@"Phone %i - %i"        , i, testIndex];
        person.myDescription      = [NSString stringWithFormat:@"Description %i - %i"  , i, testIndex];
        person.occupation         = [NSString stringWithFormat:@"Occupation %i - %i"   , i, testIndex];
        person.hobby              = [NSString stringWithFormat:@"Hobby %i - %i"        , i, testIndex];
        person.mainLocation       = [NSString stringWithFormat:@"Main Location %i - %i", i, testIndex];
        
        person.distanceInMeeters  = [self testGetRandomDistance];
    }
    
    [self _allignData];
	
    testIndex++;
}

- (void) testAddMessageWithFriend
{
    if (self.currentUser == nil || [self.friends count] == 0)
    {
        return;
    }
    
    SnaPerson *friend = nil;
    
    for (; friend == nil; )
    {
        friend = [self testGetRandomFriend];
        
        if (friend == self.currentUser)
        {
            friend = nil;
        }
    }
    
    [FxAssert isNotNullValue:friend];
    
    [self testAddMessageWithPerson:friend];
}
- (void) testAddMessageWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
	
    static int testIndex = 1001;
    
    int direction = random() % 2;
    
    if (direction == 0)
    {
        [self _registerMessageWithString:[NSString stringWithFormat:@"Message %d", testIndex] from:self.currentUser to:person];
    }
    else
    {
        [self _registerMessageWithString:[NSString stringWithFormat:@"Message %d", testIndex] from:person to:self.currentUser];
    }
    
    [self _allignData];
    
    testIndex++;
}

- (void) testMutateTargetRange
{
    int index = random() % [self.availableTargetingRanges count];
    
    self.targetingRange = [self.availableTargetingRanges objectAtIndex:index];
    
    [self _allignData];
}

- (void) testMutateMessages
{
    BOOL shouldSetToRead = YES;
    
    for (int i = 0; i < _messages.count; i++)
    {
        SnaMutableMessage *message = [_messages objectAtIndex:i];
        
        if (!message.isRead)
        {
            if (shouldSetToRead)
            {
                message.readOn = [NSDate date];
            }
            
            shouldSetToRead = !shouldSetToRead;
        }
    }
    
    [self _allignData];
}

#endif

@end
