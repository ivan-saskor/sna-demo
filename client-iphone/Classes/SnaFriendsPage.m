
#import "SnaFriendsPage.h"

@implementation SnaFriendsPageModel

@synthesize friends = _friends;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithFriends:(NSArray *)friends
{
    [FxAssert isNotNullArgument:friends withName:@"friends"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _friends = [friends retain];
    
    return self;
}

- (void) dealloc
{
    [_friends release];
    
    [super dealloc];
}

@end
@implementation SnaFriendsPageController

- (id) init
{
    _isInitStarted_SnaFriendsPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaFriendsPageModel alloc] initWithFriends:self.dataService.friends];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaFriendsPageController)
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
    super.title     = @"Friends";
    super.backTitle = @"Friends";
    
    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];

    FxUiSection *dataSection = [super addSection];
    {
        for (SnaPerson *person in _model.friends)
        {
            [dataSection addItem1CellWithCaptionBoundObject:person captionPropertyKey:@"nick" contentBoundObject:person contentPropertyKey:@"mood" targetObject:self action:@selector(openPerson:) actionContext:person];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Add 5 Persons (1 friend)"  targetObject:self action:@selector(testAddFivePersons:)];
            [testSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons: )];
            [testSection addButtonCellWithCaption:@"Log Out"        targetObject:self action:@selector(testLogOut:        )];
        }
    }
    #endif
}

- (void) openPerson:(SnaPerson *)person
{
    [self showPersonPageForPerson:person];
}

#ifdef DEBUG

- (void) testAddFivePersons:(id)sender
{
    [self.dataService testAddFivePersons];
}
- (void) testMutatePersons:(id)sender
{
    [self.dataService testMutatePersons];
}
- (void) testLogOut:(id)sender
{
    [self removeAllPageRefreshTriggers];

    [self.dataService logOut];
    
    [self showLogInPage];
}

#endif

@end
