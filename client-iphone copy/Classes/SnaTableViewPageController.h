
#import "_Fx.h"
#import "_Services.h"

typedef enum
{
    SnaNewMessageActionTypeSendMessage,
    SnaNewMessageActionTypeRequestFriendship,
    SnaNewMessageActionTypeAcceptFriendship,
    SnaNewMessageActionTypeRejectFriendship,
    SnaNewMessageActionTypeCancelFriendship
    
} SnaNewMessageActionType;

@interface SnaTableViewPageController : FxTableViewController
{
    @private BOOL _isInitStarted_SnaTableViewPageController;
    
    @private SnaDataService *_dataService;
}

@property(nonatomic, retain, readonly) SnaDataService *dataService;

- (void) showLogInPage;
- (void) showSignUpPage;
- (void) showHomePage;

- (void) showNearbyPersonsPage;
- (void) showFriendsPage;
- (void) showPersonPageForPerson  :(SnaPerson  *)person;

- (void) showMessagesPage;
- (void) showMessagesPageForPerson:(SnaPerson  *)person;
- (void) showMessagePageForMessage:(SnaMessage *)message;

- (void) showFriendshipRequestsPage;

- (void) showProfilePage;
- (void) showChangeMoodPage;
- (void) showChangeLocationPage;

- (void) showNewMessagePageWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text;

@end
