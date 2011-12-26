
#import "_Fx.h"

@interface SnaFriendshipStatus : FxEnum
{
    @private NSString *_name;
}

+ (SnaFriendshipStatus *) SELF           ;
+ (SnaFriendshipStatus *) FRIEND         ;
+ (SnaFriendshipStatus *) ALIEN          ;
+ (SnaFriendshipStatus *) WAITING_FOR_HIM;
+ (SnaFriendshipStatus *) WAITING_FOR_ME ;
+ (SnaFriendshipStatus *) REJECTED       ;

+ (NSArray *)values;

@property(readonly, copy) NSString *name;

@end
