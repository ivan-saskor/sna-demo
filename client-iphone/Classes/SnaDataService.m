
#import "_Services.h"

@interface SnaDataService()

@property (nonatomic, assign, readwrite) NSInteger    timestamp;

@property (nonatomic,   copy, readwrite) NSString    *defaultLogInEmail;
@property (nonatomic,   copy, readwrite) NSString    *defaultLogInPassword;

@property (nonatomic, retain, readwrite) SnaPerson   *currentUser;

@property (nonatomic, retain, readwrite) SnaLocation *currentLocation;

- (void) _fillTestData;

- (SnaPerson  *) _registerPersonWithString :(NSString *)string;
- (SnaPerson *)  _registerPersonWithEmail  :(NSString *)email password:(NSString *)password nick:(NSString *)nick;
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

- (void) _allignPersons_relationshipStatuses;
- (void) _allignPersons_messagess;
- (void) _allignPersons_refreshCalculatedFields_CHAMPION;

- (void) _allignNearbyPersons;
- (void) _allignFriends;
- (void) _allignWaitingForMePersons;
- (void) _allignWaitingForHimPersons;
- (void) _allignRejectedPersons;

- (void) _allignFriendsWithMessages;

- (NSArray *) _findMessagesWithPerson:(SnaPerson *)person;

- (NSArray *) _findNearbyPersons;
- (NSArray *) _findFriends;
- (NSArray *) _findWaitingForMePersons;
- (NSArray *) _findWaitingForHimPersons;
- (NSArray *) _findRejectedPersons;

- (NSArray *) _findFriendsWithMessages;

@end
@implementation SnaDataService

+ (SnaDataService *) INSTANCE
{
    static SnaDataService *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaDataService alloc] init];
    }
    
    return cachedResult;
}

@synthesize timestamp            = _timestamp;

@synthesize defaultLogInEmail    = _defaultLogInEmail;
@synthesize defaultLogInPassword = _defaultLogInPassword;

@synthesize currentUser          = _currentUser;

@synthesize nearbyPersons        = _nearbyPersons;
@synthesize friends              = _friends;
@synthesize waitingForMePersons  = _waitingForMePersons;
@synthesize waitingForHimPersons = _waitingForHimPersons;
@synthesize rejectedPersons      = _rejectedPersons;

@synthesize friendsWithMessages  = _friendsWithMessages;

@synthesize currentLocation      = _currentLocation;
@synthesize availableLocations   = _availableLocations;

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

    _availableLocations   = [[NSArray alloc] initWithObjects:
        
        [[SnaImmutableLocation alloc] initWithName:@"Split" latitude:[FxDecimalTools decimalFromMantisa:1 exponent:0 isNegative:FALSE] longitude:[FxDecimalTools decimalFromMantisa:1 exponent:0 isNegative:FALSE]],
        [[SnaImmutableLocation alloc] initWithName:@"Bol"   latitude:[FxDecimalTools decimalFromMantisa:2 exponent:0 isNegative:FALSE] longitude:[FxDecimalTools decimalFromMantisa:2 exponent:0 isNegative:FALSE]],
        [[SnaImmutableLocation alloc] initWithName:@"Čišla" latitude:[FxDecimalTools decimalFromMantisa:3 exponent:0 isNegative:FALSE] longitude:[FxDecimalTools decimalFromMantisa:3 exponent:0 isNegative:FALSE]],
        nil
    ];
    
    #if DEBUG
    {
        _personA = nil;
        _personB = nil;
    }
    #endif
    
    [self _fillTestData];
    
    [self _logInPerson:[_persons objectAtIndex:0]];
    self.currentLocation = [self.availableLocations objectAtIndex:0];
    
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

    #if DEBUG
    {
        [_personA          release];
        [_personB          release];
    }
    #endif
    
	[super dealloc];
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
    
    SnaPerson *person = [self _tryFindPersonWithEmail:email password:password];

    if (person == nil)
    {
        return NO;
    }

    [self _logInPerson:person];
    
    return YES;
}
- (BOOL) trySignUpWithEmail:(NSString *)email password:(NSString *)password nick:(NSString *)nick
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

    SnaPerson *person = [self _registerPersonWithEmail:email password:password nick:nick];
    
    [self _logInPerson:person];

    return YES;
}
- (void) logOut
{
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    self.currentUser = nil;
    
    [self _allignData];
}

- (void) requestFriendshipToPerson:(SnaPerson *)person withMessage:(NSString *)message
{
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];

    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus    ALIEN]
                         || person.friendshipStatus == [SnaFriendshipStatus REJECTED]) reason:@"Invalid person status"];

    [FxAssert isValidState:(![self _areFriendsPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:person toPerson:self.currentUser]) reason:@"Corrupted data"];
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:self.currentUser toPerson:person]) reason:@"Corrupted data"];
    
    if ([self _areRejectedPerson:self.currentUser andPerson:person])
    {
        [self _unregisterRejectedPerson:self.currentUser andPerson:person];
    }
    
    [FxAssert isValidState:(![self _areInRelationPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [self _registerFriendshipRequestFromPerson:self.currentUser toPerson:person];
    [self _registerMessageWithString:message from:self.currentUser to:person];
    
    [self _allignData];
}
- (void) acceptFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];
    
    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME]) reason:@"Invalid person status"];

    [FxAssert isValidState:(![self _areFriendsPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [FxAssert isValidState:( [self _existsFriendshipRequestFromPerson:person toPerson:self.currentUser]) reason:@"Corrupted data"];
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:self.currentUser toPerson:person]) reason:@"Corrupted data"];

    [self _unregisterFriendshipRequestFromPerson:person toPerson:self.currentUser];
    
    [FxAssert isValidState:(![self _areInRelationPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [self _registerAsFriendsPerson:self.currentUser andPerson:person];
    [self _registerMessageWithString:message from:self.currentUser to:person];
   
    [self _allignData];
}
- (void) rejectFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME]) reason:@"Invalid person status"];
    
    [FxAssert isValidState:(![self _areFriendsPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [FxAssert isValidState:( [self _existsFriendshipRequestFromPerson:person toPerson:self.currentUser]) reason:@"Corrupted data"];
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:self.currentUser toPerson:person]) reason:@"Corrupted data"];
    
    [self _unregisterFriendshipRequestFromPerson:person toPerson:self.currentUser];
    
    [FxAssert isValidState:(![self _areInRelationPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [self _registerAsRejectedPerson:self.currentUser andPerson:person];
    [self _registerMessageWithString:message from:self.currentUser to:person];
    
    [self _allignData];
}
- (void) cancelFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message
{
    [FxAssert isNotNullArgument        :person  withName:@"person"];
    [FxAssert isValidArgument          :person  withName:@"person" validation:[_persons containsObject:person]];
    [FxAssert isNotNullNorEmptyArgument:message withName:@"message"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    [FxAssert isValidState:(person.friendshipStatus == [SnaFriendshipStatus FRIEND]) reason:@"Invalid person status"];
    
    [FxAssert isValidState:( [self _areFriendsPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:person toPerson:self.currentUser]) reason:@"Corrupted data"];
    [FxAssert isValidState:(![self _existsFriendshipRequestFromPerson:self.currentUser toPerson:person]) reason:@"Corrupted data"];
    
    [self _unregisterFriendsPerson:self.currentUser andPerson:person];

    [FxAssert isValidState:(![self _areInRelationPerson:self.currentUser andPerson:person]) reason:@"Corrupted data"];
    
    [self _registerAsRejectedPerson:self.currentUser andPerson:person];
    [self _registerMessageWithString:message from:self.currentUser to:person];
    
    [self _allignData];
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
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:1212121212121"]];
    //
}

- (void) changeMood:(NSString *)mood
{
    [FxAssert isNotNullArgument:mood withName:@"mood"];
    
    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    ((SnaMutablePerson *)self.currentUser).mood = mood;
    
    [self _allignData];
}
- (void) changeLocation:(SnaLocation *)location
{
    [FxAssert isNotNullArgument:location withName:@"location"];
    [FxAssert isValidArgument  :location withName:@"location" validation:[_availableLocations containsObject:location]];

    [FxAssert isValidState:(self.currentUser != nil) reason:@"User is not logged in"];

    self.currentLocation = location;
    
    [self _allignData];
}

- (void) sendMessageWithText:(NSString *)text toPerson:(SnaPerson *)toPerson
{
    [FxAssert isNotNullNorEmptyArgument:text   withName:@"text"];
    [FxAssert isNotNullArgument        :toPerson withName:@"toPerson"];
    [FxAssert isValidArgument          :toPerson withName:@"toPerson" validation:[_persons containsObject:toPerson]];

    [self _registerMessageWithString:text from:self.currentUser to:toPerson];
    
    [self _allignData];
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
- (SnaPerson *)  _registerPersonWithEmail:(NSString *)email password:(NSString *)password nick:(NSString *)nick
{
    [FxAssert isNotNullNorEmptyArgument:email    withName:@"email"   ];
    [FxAssert isNotNullNorEmptyArgument:password withName:@"password"];
    [FxAssert isNotNullNorEmptyArgument:nick     withName:@"nick"    ];
    
    [FxAssert isValidArgument:email withName:@"email" validation:![self _existsPersonWithEmail:email]];
    [FxAssert isValidArgument:email withName:@"nick"  validation:![self _existsPersonWithNick:nick  ]];
    
    SnaPerson *person = [[[SnaMutablePerson alloc] initWithEmail:email
                                                        password:password
                          
                                                visibilityStatus:[SnaVisibilityStatus ONLINE]
                                                    offlineSince:nil
                          
                                                friendshipStatus:[SnaFriendshipStatus SELF]
                                                      rejectedOn:nil
                          
                                                            nick:nick
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
    
    [_messages addObject:message];
    
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

- (void) _logInPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    [FxAssert isValidArgument  :person withName:@"person" validation:[_persons containsObject:person]];
    
    [FxAssert isValidState:(self.currentUser == nil) reason:@"User is already logged in"];

    self.currentUser = person;
    
    [self _allignData];
}

- (void) _allignData
{
    [self _allignPersons_relationshipStatuses            ];
    [self _allignPersons_messagess                       ];
    [self _allignPersons_refreshCalculatedFields_CHAMPION];
    
    [self _allignNearbyPersons                           ];
    [self _allignFriends                                 ];
    [self _allignWaitingForMePersons                     ];
    [self _allignWaitingForHimPersons                    ];
    [self _allignRejectedPersons                         ];
    
    [self _allignFriendsWithMessages                     ];
    
    self.timestamp++;
}

- (void) _allignPersons_relationshipStatuses
{
    for (SnaMutablePerson *person in _persons)
    {
        if (self.currentUser == nil || self.currentUser == person)
        {
            person.friendshipStatus = [SnaFriendshipStatus SELF];
        }
        else if ([self _areFriendsPerson:self.currentUser andPerson:person])
        {
            person.friendshipStatus = [SnaFriendshipStatus FRIEND];
        }
        else if ([self _existsFriendshipRequestFromPerson:self.currentUser toPerson:person])
        {
            person.friendshipStatus = [SnaFriendshipStatus WAITING_FOR_HIM];
        }
        else if ([self _existsFriendshipRequestFromPerson:person toPerson:self.currentUser])
        {
            person.friendshipStatus = [SnaFriendshipStatus WAITING_FOR_ME];
        }
        else if ([self _areRejectedPerson:self.currentUser andPerson:person])
        {
            person.friendshipStatus = [SnaFriendshipStatus REJECTED];
        }
        else
        {
            person.friendshipStatus = [SnaFriendshipStatus ALIEN];
        }
    }
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
    NSMutableArray *result = [[_persons mutableCopy] autorelease];
    
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
