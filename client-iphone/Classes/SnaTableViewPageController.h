
#import "_Fx.h"
#import "_Services.h"

@interface SnaTableViewPageController : FxTableViewController
{
    @private BOOL _isInitStarted_SnaTableViewPageController;
    
    @private SnaDataService *_dataService;
}

@property(nonatomic, retain, readonly) SnaDataService *dataService;

- (void) showLogInPage;
- (void) showHomePage;

- (void) showNearbyPersonsPage;
- (void) showFriendsPage;
- (void) showPersonPageForPerson  :(SnaPerson  *)person;

- (void) showMessagesPage;
- (void) showMessagesPageForPerson:(SnaPerson  *)person;
- (void) showMessagePageForMessage:(SnaMessage *)message;

- (void) showFriendshipRequestsPage;

- (void) showProfilePage;

@end
