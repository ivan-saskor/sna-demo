
#import "SnaTableViewPageController.h"

#import "_Pages.h"

#import "SnaApplicationDelegate.h"

@implementation SnaTableViewPageController

- (id) init
{
    if (_isInitStarted_SnaTableViewPageController)
    {
        return [super init];
    }
    else
    {
        return [self initWithStyle:UITableViewStyleGrouped];
    }
}
- (id) initWithStyle:(UITableViewStyle)style
{
    _isInitStarted_SnaTableViewPageController = YES;

    self = [super initWithStyle:style];
    
    if (!self) @throw [NSException exceptionWithName:@"Init failed" reason:nil userInfo:nil];
    
    _dataService = [[SnaDataService INSTANCE] retain];

    return self;
}

- (void) dealloc
{
    [_dataService release];
    
	[super dealloc];
}

@synthesize dataService = _dataService;

- (void) showLogInPage
{
    [[SnaApplicationDelegate INSTANCE] flipToLoginPage];
//    SnaLogInPageController *pageController = [[[SnaLogInPageController alloc] init] autorelease];
//    
//    [self flipViewController:pageController];
}
- (void) showSignUpPage
{
    SnaSignUpPageController *pageController = [[[SnaSignUpPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showHomePage
{
    [[SnaApplicationDelegate INSTANCE] flipToHomePage];
//    SnaHomePageController *pageController = [[[SnaHomePageController alloc] init] autorelease];
//    
//    [self flipViewController:pageController];
}

- (void) showNearbyPersonsPage
{
    SnaNearbyPersonsPageController *pageController = [[[SnaNearbyPersonsPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showFriendsPage
{
    SnaFriendsPageController *pageController = [[[SnaFriendsPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}

- (void) showPersonPageForPerson  :(SnaPerson  *)person
{
    SnaPersonPageController *pageController = [[[SnaPersonPageController alloc] initWithPerson:person] autorelease];
    
    [self pushViewController:pageController];
}

- (void) showMessagesPage
{
    SnaMessagesPageController *pageController = [[[SnaMessagesPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showMessagesPageForPerson:(SnaPerson  *)person
{
    SnaMessagesWithPersonPageController *pageController = [[[SnaMessagesWithPersonPageController alloc] initWithPerson:person] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showMessagePageForMessage:(SnaMessage *)message
{
    SnaMessagePageController *pageController = [[[SnaMessagePageController alloc] initWithMessage:message] autorelease];
    
    [self pushViewController:pageController];
}

- (void) showFriendshipRequestsPage
{
    SnaFriendshipRequestsPageController *pageController = [[[SnaFriendshipRequestsPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}

- (void) showProfilePage
{
    SnaProfilePageController *pageController = [[[SnaProfilePageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showChangeMoodPage
{
    SnaChangeMoodPageController *pageController = [[[SnaChangeMoodPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}
- (void) showChangeLocationPage
{
    SnaChangeLocationPageController *pageController = [[[SnaChangeLocationPageController alloc] init] autorelease];
    
    [self pushViewController:pageController];
}

- (void) showNewMessagePageWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text
{
    SnaNewMessagePageController *pageController = [[[SnaNewMessagePageController alloc] initWithActionType:actionType toPerson:toPerson text:text] autorelease];
    
    [self pushViewController:pageController];
}

@end
