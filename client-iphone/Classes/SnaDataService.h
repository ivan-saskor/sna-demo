
#import "_Fx.h"
#import "_Domain.h"

@interface SnaDataService : NSObject
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

    #ifdef DEBUG
    
    @private SnaPerson           *_personA;
    @private SnaPerson           *_personB;

    #endif
}

+ (SnaDataService *) INSTANCE;

@property (nonatomic, assign, readonly) NSInteger timestamp;

@property (nonatomic,   copy, readonly) NSString *defaultLogInEmail;
@property (nonatomic,   copy, readonly) NSString *defaultLogInPassword;

@property (nonatomic, retain, readonly) SnaPerson *currentUser;

@property (nonatomic        , readonly) NSArray   *nearbyPersons;
@property (nonatomic        , readonly) NSArray   *friends;
@property (nonatomic        , readonly) NSArray   *waitingForMePersons;
@property (nonatomic        , readonly) NSArray   *waitingForHimPersons;
@property (nonatomic        , readonly) NSArray   *rejectedPersons;

@property (nonatomic        , readonly) NSArray   *friendsWithMessages;

- (void) logInWithEmail:(NSString *)email password:(NSString *)password;
- (void) logOut;

- (void) requestFriendshipToPerson:(SnaPerson *)person;
- (void) acceptFriendshipToPerson :(SnaPerson *)person;
- (void) rejectFriendshipToPerson :(SnaPerson *)person;
- (void) cancelFriendshipToPerson :(SnaPerson *)person;

- (void) callPerson               :(SnaPerson *)person;

#ifdef DEBUG

- (void) testLogInPersonA;
- (void) testLogInPersonB;
- (void) testLogInRandomPerson;

- (SnaPerson *) testGetRandomPerson;
- (SnaPerson *) testGetRandomFriend;

- (void) testAddFivePersons;
- (void) testMutatePersons;

- (void) testAddMessageWithFriend;
- (void) testAddMessageWithPerson:(SnaPerson *)person;
- (void) testMutateMessages;

#endif

@end
