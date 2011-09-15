
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
    
    @private SnaLocation         *_currentLocation;
    @private NSArray             *_availableLocations;

    #ifdef DEBUG
    
    @private SnaPerson           *_personA;
    @private SnaPerson           *_personB;

    #endif
}

+ (SnaDataService *) INSTANCE;

@property (nonatomic, assign, readonly) NSInteger timestamp;

@property (nonatomic,   copy, readonly) NSString   *defaultLogInEmail;
@property (nonatomic,   copy, readonly) NSString   *defaultLogInPassword;

@property (nonatomic, retain, readonly) SnaPerson   *currentUser;

@property (nonatomic        , readonly) NSArray     *nearbyPersons;
@property (nonatomic        , readonly) NSArray     *friends;
@property (nonatomic        , readonly) NSArray     *waitingForMePersons;
@property (nonatomic        , readonly) NSArray     *waitingForHimPersons;
@property (nonatomic        , readonly) NSArray     *rejectedPersons;

@property (nonatomic        , readonly) NSArray     *friendsWithMessages;

@property (nonatomic, retain, readonly) SnaLocation *currentLocation;
@property (nonatomic        , readonly) NSArray     *availableLocations;

- (BOOL) tryLogInWithEmail :(NSString *)email password:(NSString *)password;
- (BOOL) trySignUpWithEmail:(NSString *)email password:(NSString *)password nick:(NSString *)nick;
- (void) logOut;

- (void) requestFriendshipToPerson:(SnaPerson *)person withMessage:(NSString *)message;
- (void) acceptFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;
- (void) rejectFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;
- (void) cancelFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;

- (void) callPerson               :(SnaPerson *)person;

- (void) changeMood    :(NSString    *)mood;
- (void) changeLocation:(SnaLocation *)location;

- (void) sendMessageWithText:(NSString *)text toPerson:(SnaPerson *)toPerson;

#ifdef DEBUG

- (void) testLogInPersonA;
- (void) testLogInPersonB;
- (void) testLogInRandomPerson;

- (SnaPerson *) testGenerateNewProfile;

- (SnaPerson *) testGetRandomPerson;
- (SnaPerson *) testGetRandomFriend;

- (void) testAddFivePersons;
- (void) testMutatePersons;

- (void) testAddMessageWithFriend;
- (void) testAddMessageWithPerson:(SnaPerson *)person;
- (void) testMutateMessages;

#endif

@end
