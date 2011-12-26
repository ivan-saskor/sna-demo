
#import "SnaHomePage.h"

@implementation SnaHomePageModel

- (id) init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
@implementation SnaHomePageController

- (id) init
{
    _isInitStarted_SnaHomePageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaHomePageModel alloc] init];

    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaHomePageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

- (void) onPageRefresh
{
    super.title     = @"Social Network 3D";
    super.backTitle = @"Home";
    
    FxUiSection *menuSection = [super addSection];
    {
        [menuSection addButtonCellWithCaption:@"Nearby Persons"      targetObject:self action:@selector(showNearbyPersonsPage:     )];
        [menuSection addButtonCellWithCaption:@"Friends"             targetObject:self action:@selector(showFriendsPage:           )];
        [menuSection addButtonCellWithCaption:@"Messages"            targetObject:self action:@selector(showMessagesPage:          )];
        [menuSection addButtonCellWithCaption:@"Friendship Requests" targetObject:self action:@selector(showFriendshipRequestsPage:)];
        [menuSection addButtonCellWithCaption:@"Profile"             targetObject:self action:@selector(showProfilePage:           )];
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Log Out" targetObject:self action:@selector(testLogOut:)];
        }
    }
    #endif
}

- (void) showNearbyPersonsPage:(id)sender
{
    [self showNearbyPersonsPage];
}
- (void) showFriendsPage:(id)sender
{
    [self showFriendsPage];
}
- (void) showMessagesPage:(id)sender
{
    [self showMessagesPage];
}
- (void) showFriendshipRequestsPage:(id)sender
{
    [self showFriendshipRequestsPage];
}
- (void) showProfilePage:(id)sender
{
    [self showProfilePage];
}

#ifdef DEBUG

- (void) testLogOut:(id)sender
{
    [self removeAllPageRefreshTriggers];
    
    [self.dataService logOut];
    
    [self showLogInPage];
}

#endif

@end
