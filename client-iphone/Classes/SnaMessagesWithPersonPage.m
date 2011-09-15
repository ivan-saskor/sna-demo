
#import "SnaMessagesWithPersonPage.h"

@implementation SnaMessagesWithPersonPageModel

@synthesize person   = _person;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person   withName:@"person"  ];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _person   = [person   retain];
    
    return self;
}

- (void) dealloc
{
    [_person   release];
    
    [super dealloc];
}

@end
@implementation SnaMessagesWithPersonPageController

- (id) init
{
    if (_isInitStarted_SnaMessagesWithPersonPageController)
    {
        return [super init];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}
- (id) initWithPerson:(SnaPerson *)person
{
    [FxAssert isNotNullArgument:person withName:@"person"];

    _isInitStarted_SnaMessagesWithPersonPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaMessagesWithPersonPageModel alloc] initWithPerson:person];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaMessagesWithPersonPageController)
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
    super.title     = _model.person.nick;
    super.backTitle = _model.person.nick;
    
    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(openNewMessagePage:)] autorelease];

    FxUiSection *dataSection = [super addSection];
    {
        for (SnaMessage *message in [_model.person.messages reverseObjectEnumerator])
        {
            [dataSection addItem2CellWithCaptionBoundObject:message.from captionPropertyKey:@"nick" contentBoundObject:message contentPropertyKey:@"text"  accesoryType:UITableViewCellAccessoryNone];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Add Message"     targetObject:self action:@selector(testAddMessage:    )];
            [testSection addButtonCellWithCaption:@"Mutate Persons"  targetObject:self action:@selector(testMutatePersons: )];
            [testSection addButtonCellWithCaption:@"Log Out"         targetObject:self action:@selector(testLogOut:        )];
        }
    }
    #endif
}

- (void) openNewMessagePage:(id)sender
{
    [self showNewMessagePageWithActionType:SnaNewMessageActionTypeSendMessage toPerson:_model.person text:@""];
}

- (void) openMessage:(SnaMessage *)message
{
    [self showMessagePageForMessage:message];
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

#ifdef DEBUG

- (void) testAddMessage:(id)sender
{
    [self.dataService testAddMessageWithPerson:_model.person];
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
