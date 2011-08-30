
#import "_Fx.h"

@class SnaVisibilityStatus, SnaFriendshipStatus, SnaMessage;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaPerson : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString            *email;
@property(nonatomic, readonly, copy  ) NSString            *password;
@property(nonatomic, readonly, assign) SnaVisibilityStatus *visibilityStatus;
@property(nonatomic, readonly, assign) SnaFriendshipStatus *friendshipStatus;
@property(nonatomic, readonly, copy  ) NSString            *nick;
@property(nonatomic, readonly, copy  ) NSString            *mood;
@property(nonatomic, readonly, copy  ) NSString            *phone;
@property(nonatomic, readonly, copy  ) NSArray             *messages;

@property(nonatomic, readonly, retain) SnaMessage          *lastMessage;
@property(nonatomic, readonly, assign) NSInteger            unreadMessagesCount;

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
    @private SnaFriendshipStatus *_friendshipStatus;
    @private NSString            *_nick;
    @private NSString            *_mood;
    @private NSString            *_phone;
    @private NSArray             *_messages;
}

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone
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
    @private SnaFriendshipStatus *_friendshipStatus;
    @private NSString            *_nick;
    @private NSString            *_mood;
    @private NSString            *_phone;
    @private NSMutableArray      *_messages;
}

@property(nonatomic, readwrite, copy  ) NSString            *email;
@property(nonatomic, readwrite, copy  ) NSString            *password;
@property(nonatomic, readwrite, assign) SnaVisibilityStatus *visibilityStatus;
@property(nonatomic, readwrite, assign) SnaFriendshipStatus *friendshipStatus;
@property(nonatomic, readwrite, copy  ) NSString            *nick;
@property(nonatomic, readwrite, copy  ) NSString            *mood;
@property(nonatomic, readwrite, copy  ) NSString            *phone;
@property(nonatomic, readonly,  copy  ) NSMutableArray      *messages;

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone;

- (id) initWithEmail:(NSString            *)email
            password:(NSString            *)password
    visibilityStatus:(SnaVisibilityStatus *)visibilityStatus
    friendshipStatus:(SnaFriendshipStatus *)friendshipStatus
                nick:(NSString            *)nick
                mood:(NSString            *)mood
               phone:(NSString            *)phone
            messages:(NSArray             *)messages;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


//----------------------
// TO-DO
//----------------------
//
// + email
// + password
//
// + visibilityStatus
// - offlineSince
//
// + friendshipStatus
// - rejectedOn
//
// + nick
// + mood
// - gravatarCode
//
// - bornOn
// - gender
// - lookingForGenders
//
// + phone
// - description
// - ocupation
// - hobby
// - mainLocation
//
// - lastKnownLocation
// - distanceInMeeters
//
//----------------------
