
#import "SnaMessagesPage.h"

@implementation SnaMessagesPageModel

@synthesize friendsWithMessages = _friendsWithMessages;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithFriendsWithMessages:(NSArray *)friendsWithMessages
{
    [FxAssert isNotNullArgument:friendsWithMessages withName:@"friendsWithMessages"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _friendsWithMessages = [friendsWithMessages retain];
    
    return self;
}

- (void) dealloc
{
    [_friendsWithMessages release];
    
    [super dealloc];
}

@end
@implementation SnaMessagesPageController

- (id) init
{
    _isInitStarted_SnaMessagesPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaMessagesPageModel alloc] initWithFriendsWithMessages:self.dataService.friendsWithMessages];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaMessagesPageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}

- (void) onPageRefresh
{
    super.title     = @"Messages";
    super.backTitle = @"Messages";
    
    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];

    FxUiSection *dataSection = [super addSection];
    {
        for (SnaPerson *friend in _model.friendsWithMessages)
        {
            [dataSection addItem1CellWithCaptionBoundObject:friend captionPropertyKey:@"nick" contentBoundObject:friend.lastMessage contentPropertyKey:@"text" targetObject:self action:@selector(openMessages:) actionContext:friend];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Add Message"     targetObject:self action:@selector(testAddMessage:    )];
            [testSection addButtonCellWithCaption:@"Mutate Messages" targetObject:self action:@selector(testMutateMessages:)];
            [testSection addButtonCellWithCaption:@"Mutate Persons"  targetObject:self action:@selector(testMutatePersons: )];
            [testSection addButtonCellWithCaption:@"Log Out"         targetObject:self action:@selector(testLogOut:        )];
        }
    }
    #endif
}

- (void) openMessages:(SnaPerson *)person
{
    [self showMessagesPageForPerson:person];
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

#ifdef DEBUG

- (void) testAddMessage:(id)sender
{
    [self.dataService testAddMessageWithFriend];
}
- (void) testMutateMessages:(id)sender
{
    [self.dataService testMutateMessages];
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
