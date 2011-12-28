
#import "SnaMessagePage.h"

@implementation SnaMessagePageModel

@synthesize message = _message;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithMessage:(SnaMessage *)message
{
    [FxAssert isNotNullArgument:message withName:@"message"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _message = [message retain];
    
    return self;
}

- (void) dealloc
{
    [_message release];
    
    [super dealloc];
}

@end
@implementation SnaMessagePageController

- (id) init
{
    if (_isInitStarted_SnaMessagePageController)
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
    if (_isInitStarted_SnaMessagePageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}
- (id) initWithMessage:(SnaMessage *)message
{
    [FxAssert isNotNullArgument:message withName:@"message"];
    
    _isInitStarted_SnaMessagePageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaMessagePageModel alloc] initWithMessage:message];
    
    return self;
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

- (void) onPageRefresh
{
    super.title     = @"Message";
    super.backTitle = @"Message";
    
    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];
    
    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextBlockCellWithCaption:@"from"   boundObject:_model.message propertyKey:@"from"   displayPropertyKey:@"nick"];
        [dataSection addTextBlockCellWithCaption:@"to"     boundObject:_model.message propertyKey:@"to"     displayPropertyKey:@"nick"];
//        [dataSection addTextBlockCellWithCaption:@"sent on" boundObject:_model.message propertyKey:@"sentOn"                           ];
    }
    FxUiSection *textSection = [super addSection];
    {
        [textSection addTextBlockCellWithCaption:@"text"   boundObject:_model.message propertyKey:@"text"                             ];
    }
    
    FxUiSection *buttonsSection = [super addSection];
    {
        [buttonsSection addButtonCellWithCaption:@"Reply" targetObject:self action:@selector(reply:)];
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testDataSection = [super addSectionWithCaption:@"Test"];
        {
            [testDataSection addTextBlockCellWithCaption:@"message id" boundObject:_model.message propertyKey:@"id"    ];
//            [testDataSection addTextBlockCellWithCaption:@"read on"    boundObject:_model.message propertyKey:@"readOn"];
//            [testDataSection addTextBlockCellWithCaption:@"is read"    boundObject:_model.message propertyKey:@"isRead"];
        }
        FxUiSection *testButtonsSection = [super addSection];
        {
            [testButtonsSection addButtonCellWithCaption:@"Mutate Messages" targetObject:self action:@selector(testMutateMessages:)];
            [testButtonsSection addButtonCellWithCaption:@"Mutate Persons"  targetObject:self action:@selector(testMutatePersons: )];
            [testButtonsSection addButtonCellWithCaption:@"Log Out"         targetObject:self action:@selector(testLogOut:        )];
        }
    }
    #endif
}

- (void) reply:(id)sender
{
}

#ifdef DEBUG

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
