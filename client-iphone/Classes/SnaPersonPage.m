
#import "SnaPersonPage.h"

@implementation SnaPersonPageModel

@synthesize person = _person;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _person = [person retain];
    
    return self;
}

- (void) dealloc
{
    [_person release];
    
    [super dealloc];
}

@end
@implementation SnaPersonPageController

- (id) init
{
    if (_isInitStarted_SnaPersonPageController)
    {
        return [super init];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaPersonPageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}
- (id) initWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];
    
    _isInitStarted_SnaPersonPageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaPersonPageModel alloc] initWithPerson:person];
    
    return self;
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

- (void) onPageRefresh
{
    super.title     = _model.person.nick;
    super.backTitle = _model.person.nick;

    [super addPageRefreshTriggerWithBoundObject:_model.person propertyKey:@"friendshipStatus"];

    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextBlockCellWithCaption:@"nick"       boundObject:_model.person propertyKey:@"nick"                                       ];
        [dataSection addTextBlockCellWithCaption:@"mood"       boundObject:_model.person propertyKey:@"mood"                                       ];
        [dataSection addTextBlockCellWithCaption:@"visibility" boundObject:_model.person propertyKey:@"visibilityStatus" displayPropertyKey:@"name"];
        
        if (_model.person.friendshipStatus == [SnaFriendshipStatus FRIEND])
        {
            [dataSection addTextBlockCellWithCaption:@"email" boundObject:_model.person propertyKey:@"email" ];
            [dataSection addTextBlockCellWithCaption:@"phone" boundObject:_model.person propertyKey:@"phone" ];
        }
    }
    
    FxUiSection *buttonsSection = [super addSection];
    {
        if (_model.person.friendshipStatus == [SnaFriendshipStatus ALIEN])
        {
            [buttonsSection addButtonCellWithCaption:@"Request Friendship" targetObject:self action:@selector(requestFriendship:)];
        }
        else if (_model.person.friendshipStatus == [SnaFriendshipStatus REJECTED])
        {
            [buttonsSection addButtonCellWithCaption:@"Request Friendship" targetObject:self action:@selector(requestFriendship:)];
            [buttonsSection addButtonCellWithCaption:@"Messages"           targetObject:self action:@selector(openMessages:     )];
        }
        else if (_model.person.friendshipStatus == [SnaFriendshipStatus FRIEND])
        {
            [buttonsSection addButtonCellWithCaption:@"Call"              targetObject:self action:@selector(call:            )];
            [buttonsSection addButtonCellWithCaption:@"Messages"          targetObject:self action:@selector(openMessages:    )];
            [buttonsSection addButtonCellWithCaption:@"Cancel Friendship" targetObject:self action:@selector(cancelFriendship:)];
        }
        else if (_model.person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_HIM])
        {
            [buttonsSection addButtonCellWithCaption:@"Waiting for response ..." targetObject:self action:nil                     ];
            [buttonsSection addButtonCellWithCaption:@"Messages"                 targetObject:self action:@selector(openMessages:)];
        }
        else if (_model.person.friendshipStatus == [SnaFriendshipStatus WAITING_FOR_ME])
        {
            [buttonsSection addButtonCellWithCaption:@"Accept Friendship" targetObject:self action:@selector(acceptFriendship:)];
            [buttonsSection addButtonCellWithCaption:@"Reject Friendship" targetObject:self action:@selector(rejectFriendship:)];
            [buttonsSection addButtonCellWithCaption:@"Messages"          targetObject:self action:@selector(openMessages:    )];
        }
        else
        {
            @throw [NSException exceptionWithName:@"Invalid status" reason:nil userInfo:nil];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testDataSection = [super addSectionWithCaption:@"Test"];
        {
            [testDataSection addTextBlockCellWithCaption:@"friendship" boundObject:_model.person propertyKey:@"friendshipStatus" displayPropertyKey:@"name"];
        }
        FxUiSection *testButtonsSection = [super addSection];
        {
            [testButtonsSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons:)];
            [testButtonsSection addButtonCellWithCaption:@"Log Out"        targetObject:self action:@selector(testLogOut:       )];
        }
    }
    #endif
}

- (void) call:(id)sender
{
    [self.dataService callPerson:_model.person];
}
- (void) openMessages:(id)sender
{
    [self showMessagesPageForPerson:_model.person];
}

- (void) requestFriendship:(id)sender
{
    [self.dataService requestFriendshipToPerson:_model.person];
}
- (void) acceptFriendship:(id)sender
{
    [self.dataService acceptFriendshipToPerson:_model.person];
}
- (void) rejectFriendship:(id)sender
{
    [self.dataService rejectFriendshipToPerson:_model.person];
}
- (void) cancelFriendship:(id)sender
{
    [self.dataService cancelFriendshipToPerson:_model.person];
}

#ifdef DEBUG

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
