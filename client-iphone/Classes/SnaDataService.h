
#import "_Fx.h"
#import "_Domain.h"

@protocol SnaIDataService

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

@property (nonatomic, retain, readonly) SnaTargetingRange    *targetingRange;
@property (nonatomic        , readonly) NSArray     *availableTargetingRanges;

- (BOOL) tryLogInWithEmail :(NSString *)email password:(NSString *)password;
- (void) logOut;

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
                      phone:(NSString *)phone;

//- (BOOL) trySignUpWithEmail:(NSString *)email password:(NSString *)password nick:(NSString *)nick;
- (void) requestFriendshipToPerson:(SnaPerson *)person withMessage:(NSString *)message;
- (void) acceptFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;
- (void) rejectFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;
- (void) cancelFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message;

- (void) callPerson               :(SnaPerson *)person;

- (void) changeMood    :(NSString    *)mood;
- (void) changeLocation:(SnaLocation *)location;
- (void) changeTargetingRange   :(SnaTargetingRange *) targetingRange;

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

- (void) testMutateTargetRange;

#endif

@end

@interface SnaDataService : NSObject <SnaIDataService>

+ (SnaDataService *) INSTANCE;

@end
