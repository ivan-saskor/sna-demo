
#import "SnaFriendshipRequestsPage.h"

@implementation SnaFriendshipRequestsPageModel

@synthesize waitingForMePersons  = _waitingForMePersons;
@synthesize waitingForHimPersons = _waitingForHimPersons;
@synthesize rejectedPersons      = _rejectedPersons;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithWaitingForMePersons:(NSArray *)waitingForMePersons
              waitingForHimPersons:(NSArray *)waitingForHimPersons
                   rejectedPersons:(NSArray *)rejectedPersons
{
    [FxAssert isNotNullArgument:waitingForMePersons  withName:@"waitingForMePersons" ];
    [FxAssert isNotNullArgument:waitingForHimPersons withName:@"waitingForHimPersons"];
    [FxAssert isNotNullArgument:rejectedPersons      withName:@"rejectedPersons"     ];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _waitingForMePersons  = [waitingForMePersons  retain];
    _waitingForHimPersons = [waitingForHimPersons retain];
    _rejectedPersons      = [rejectedPersons      retain];
    
    return self;
}

- (void) dealloc
{
    [_waitingForMePersons  release];
    [_waitingForHimPersons release];
    [_rejectedPersons      release];
    
    [super dealloc];
}

@end
@implementation SnaFriendshipRequestsPageController

- (id) init
{
    _isInitStarted_SnaFriendshipRequestsPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaFriendshipRequestsPageModel alloc] initWithWaitingForMePersons:self.dataService.waitingForMePersons
                                                            waitingForHimPersons:self.dataService.waitingForHimPersons
                                                                 rejectedPersons:self.dataService.rejectedPersons];
    
    super.title = @"Friendship Requests";

    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaFriendshipRequestsPageController)
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
    super.backTitle = @"Friendship Requests";
    
    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];
    
    FxUiSection *incommingSection = [super addSectionWithCaption:@"Incomming"];
    {
        for (SnaPerson *person in _model.waitingForMePersons)
        {
            [incommingSection addItem1CellWithCaptionBoundObject:person captionPropertyKey:@"nick" contentBoundObject:person.lastMessage contentPropertyKey:@"text" targetObject:self action:@selector(openPerson:) actionContext:person  accesoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    FxUiSection *outgoingSection = [super addSectionWithCaption:@"Outgoing"];
    {
        for (SnaPerson *person in _model.waitingForHimPersons)
        {
            [outgoingSection addItem1CellWithCaptionBoundObject:person captionPropertyKey:@"nick" contentBoundObject:person.lastMessage contentPropertyKey:@"text" targetObject:self action:@selector(openPerson:) actionContext:person  accesoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    FxUiSection *rejectedSection = [super addSectionWithCaption:@"Rejected"];
    {
        for (SnaPerson *person in _model.rejectedPersons)
        {
            [rejectedSection addItem1CellWithCaptionBoundObject:person captionPropertyKey:@"nick" contentBoundObject:person.lastMessage contentPropertyKey:@"text" targetObject:self action:@selector(openPerson:) actionContext:person  accesoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons: )];
            [testSection addButtonCellWithCaption:@"Add 5 Persons (1 in + 1 out + 1 rejected)"  targetObject:self action:@selector(testAddFivePersons:)];
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

- (void) testMutatePersons:(id)sender
{
    [self.dataService testMutatePersons];
}
- (void) testAddFivePersons:(id)sender
{
    [self.dataService testAddFivePersons];
}
- (void) testLogOut:(id)sender
{
    [self removeAllPageRefreshTriggers];
    
    [self.dataService logOut];
    
    [self showLogInPage];
}

#endif

@end
