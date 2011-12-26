
#import "_Services.h"

@implementation SnaDataService

+ (SnaDataService *) INSTANCE
{
    static SnaDataService *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaRealDataService alloc] init];
    }
    
    return cachedResult;
}

@synthesize timestamp             = _timestamp;

@synthesize defaultLogInEmail     = _defaultLogInEmail;
@synthesize defaultLogInPassword  = _defaultLogInPassword;

@synthesize currentUser           = _currentUser;

@synthesize nearbyPersons         = _nearbyPersons;
@synthesize friends               = _friends;
@synthesize waitingForMePersons   = _waitingForMePersons;
@synthesize waitingForHimPersons  = _waitingForHimPersons;
@synthesize rejectedPersons       = _rejectedPersons;

@synthesize friendsWithMessages   = _friendsWithMessages;

@synthesize currentLocation       = _currentLocation;
@synthesize availableLocations    = _availableLocations;

@synthesize targetingRange = _targetingRange;
@synthesize availableTargetingRanges = _availableTargetingRanges;

- (BOOL) tryLogInWithEmail :(NSString *)email password:(NSString *)password { return NO; }

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
    return NO;
}


//- (BOOL) trySignUpWithEmail:(NSString *)email password:(NSString *)password nick:(NSString *)nick { return NO; }
- (void) logOut {}

- (void) requestFriendshipToPerson:(SnaPerson *)person withMessage:(NSString *)message {}
- (void) acceptFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message {}
- (void) rejectFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message {}
- (void) cancelFriendshipToPerson :(SnaPerson *)person withMessage:(NSString *)message {}

- (void) callPerson               :(SnaPerson *)person {}

- (void) changeMood    :(NSString    *)mood {}
- (void) changeLocation:(SnaLocation *)location {}
- (void) changeTargetingRange   :(SnaTargetingRange *) targetingRange {}

- (void) sendMessageWithText:(NSString *)text toPerson:(SnaPerson *)toPerson {}

#ifdef DEBUG

- (void) testLogInPersonA {}
- (void) testLogInPersonB {}
- (void) testLogInRandomPerson {}

- (SnaPerson *) testGenerateNewProfile { return nil; }

- (SnaPerson *) testGetRandomPerson { return nil; }
- (SnaPerson *) testGetRandomFriend { return nil; }

- (void) testAddFivePersons {}
- (void) testMutatePersons {}

- (void) testAddMessageWithFriend {}
- (void) testAddMessageWithPerson:(SnaPerson *)person {}
- (void) testMutateMessages {}

- (void) testMutateTargetRange {}

#endif


@end
