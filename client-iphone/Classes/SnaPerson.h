
#import "_Fx.h"

@class SnaGender, SnaLocation, SnaVisibilityStatus, SnaFriendshipStatus, SnaMessage;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaPerson : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString            *email;
@property(nonatomic, readonly, copy  ) NSString            *password;

@property(nonatomic, readonly, assign) SnaVisibilityStatus *visibilityStatus;
@property(nonatomic, readonly, copy  ) NSDate              *offlineSince;

@property(nonatomic, readonly, assign) SnaFriendshipStatus *friendshipStatus;
@property(nonatomic, readonly, copy  ) NSDate              *rejectedOn;

@property(nonatomic, readonly, copy  ) NSString            *nick;
@property(nonatomic, readonly, copy  ) NSString            *mood;
@property(nonatomic, readonly, copy  ) NSString            *gravatarCode;

@property(nonatomic, readonly, copy  ) NSDate              *bornOn;
@property(nonatomic, readonly, assign) SnaGender           *gender;
@property(nonatomic, readonly, copy  ) NSSet               *lookingForGenders;

@property(nonatomic, readonly, copy  ) NSString            *phone;
@property(nonatomic, readonly, copy  ) NSString            *myDescription;
@property(nonatomic, readonly, copy  ) NSString            *occupation;
@property(nonatomic, readonly, copy  ) NSString            *hobby;
@property(nonatomic, readonly, copy  ) NSString            *mainLocation;

@property(nonatomic, readonly, copy  ) SnaLocation         *lastKnownLocation;
@property(nonatomic, readonly, assign) NSInteger            distanceInMeeters;

@property(nonatomic, readonly, copy  ) NSArray             *messages;

@property(nonatomic, readonly, copy  ) NSString            *bornOnAsString;            // CALCULATED
@property(nonatomic, readonly, copy  ) NSString            *lookingForGendersAsString; // CALCULATED
@property(nonatomic, readonly, copy  ) NSString            *distanceInMeetersAsString; // CALCULATED

@property(nonatomic, readonly, retain) SnaMessage          *lastMessage;               // CALCULATED
@property(nonatomic, readonly, assign) NSInteger            unreadMessagesCount;       // CALCULATED

- (void) refreshCalculatedFields_CHAMPION;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutablePerson : SnaPerson
{
    @private NSString            *_email;
    @private NSString            *_password;

    @private SnaVisibilityStatus *_visibilityStatus;
    @private NSDate              *_offlineSince;

    @private SnaFriendshipStatus *_friendshipStatus;
    @private NSDate              *_rejectedOn;

    @private NSString            *_nick;
    @private NSString            *_mood;
    @private NSString            *_gravatarCode;

    @private NSDate              *_bornOn;
    @private SnaGender           *_gender;
    @private NSSet               *_lookingForGenders;

    @private NSString            *_phone;
    @private NSString            *_myDescription;
    @private NSString            *_occupation;
    @private NSString            *_hobby;
    @private NSString            *_mainLocation;

    @private SnaLocation         *_lastKnownLocation;
    @private NSInteger            _distanceInMeeters;

    @private NSArray             *_messages;
}

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters

            messages:(NSArray             *)messages;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Mutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMutablePerson : SnaPerson
{
    @private NSString            *_email;
    @private NSString            *_password;
        
    @private SnaVisibilityStatus *_visibilityStatus;
    @private NSDate              *_offlineSince;
        
    @private SnaFriendshipStatus *_friendshipStatus;
    @private NSDate              *_rejectedOn;
        
    @private NSString            *_nick;
    @private NSString            *_mood;
    @private NSString            *_gravatarCode;
        
    @private NSDate              *_bornOn;
    @private SnaGender           *_gender;
    @private NSMutableSet        *_lookingForGenders;
        
    @private NSString            *_phone;
    @private NSString            *_myDescription;
    @private NSString            *_occupation;
    @private NSString            *_hobby;
    @private NSString            *_mainLocation;
        
    @private SnaLocation         *_lastKnownLocation;
    @private NSInteger            _distanceInMeeters;

    @private NSMutableArray      *_messages;
}

@property(nonatomic, readwrite, copy  ) NSString            *email;
@property(nonatomic, readwrite, copy  ) NSString            *password;

@property(nonatomic, readwrite, assign) SnaVisibilityStatus *visibilityStatus;
@property(nonatomic, readwrite, copy  ) NSDate              *offlineSince;

@property(nonatomic, readwrite, assign) SnaFriendshipStatus *friendshipStatus;
@property(nonatomic, readwrite, copy  ) NSDate              *rejectedOn;

@property(nonatomic, readwrite, copy  ) NSString            *nick;
@property(nonatomic, readwrite, copy  ) NSString            *mood;
@property(nonatomic, readwrite, copy  ) NSString            *gravatarCode;

@property(nonatomic, readwrite, copy  ) NSDate              *bornOn;
@property(nonatomic, readwrite, assign) SnaGender           *gender;
@property(nonatomic, readonly,  copy  ) NSMutableSet        *lookingForGenders;

@property(nonatomic, readwrite, copy  ) NSString            *phone;
@property(nonatomic, readwrite, copy  ) NSString            *myDescription;
@property(nonatomic, readwrite, copy  ) NSString            *occupation;
@property(nonatomic, readwrite, copy  ) NSString            *hobby;
@property(nonatomic, readwrite, copy  ) NSString            *mainLocation;

@property(nonatomic, readwrite, copy  ) SnaLocation         *lastKnownLocation;
@property(nonatomic, readwrite, assign) NSInteger            distanceInMeeters;

@property(nonatomic, readonly,  copy  ) NSMutableArray      *messages;

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters;

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password

    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
        offlineSince:(NSDate              *)offlineSince

    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
          rejectedOn:(NSDate              *)rejectedOn

                nick:(NSString            *)nick
                mood:(NSString            *)mood
        gravatarCode:(NSString            *)gravatarCode

              bornOn:(NSDate              *)bornOn
              gender:(SnaGender           *)gender
   lookingForGenders:(NSSet               *)lookingForGenders

               phone:(NSString            *)phone
       myDescription:(NSString            *)myDescription
          occupation:(NSString            *)occupation
               hobby:(NSString            *)hobby
        mainLocation:(NSString            *)mainLocation

   lastKnownLocation:(SnaLocation         *)lastKnownLocation
   distanceInMeeters:(NSInteger            )distanceInMeeters

            messages:(NSArray             *)messages;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
