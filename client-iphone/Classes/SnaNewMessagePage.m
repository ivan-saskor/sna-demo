
#import "SnaNewMessagePage.h"

@implementation SnaNewMessagePageModel

@synthesize actionType = _actionType;
@synthesize toPerson   = _toPerson;
@synthesize text       = _text;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text;
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
 
    _actionType = actionType;
    _toPerson   = toPerson;
    _text       = text;
    
    return self;
}

- (void) dealloc
{
    [_toPerson release];
    [_text     release];
    
    [super dealloc];
}

@end
@implementation SnaNewMessagePageController

- (id) init
{
    if (_isInitStarted_SnaNewMessagePageController)
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
    if (_isInitStarted_SnaNewMessagePageController)
    {
        return [super initWithStyle:style];
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
}
- (id) initWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text;
{
    _isInitStarted_SnaNewMessagePageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaNewMessagePageModel alloc] initWithActionType:actionType toPerson:toPerson text:text];
    
    return self;
}

- (void) dealloc
{
    [_model release];
    
    [super dealloc];
}

- (void) onPageRefresh
{
    if (_model.actionType == SnaNewMessageActionTypeSendMessage)
    {
        super.title     = @"New Message";
        super.backTitle = @"New Message";
    }
    else if (_model.actionType == SnaNewMessageActionTypeRequestFriendship)
    {
        super.title     = @"Message";
        super.backTitle = @"Message";
    }
    else if (_model.actionType == SnaNewMessageActionTypeAcceptFriendship)
    {
        super.title     = @"Message";
        super.backTitle = @"Message";
    }
    else if (_model.actionType == SnaNewMessageActionTypeRejectFriendship)
    {
        super.title     = @"Message";
        super.backTitle = @"Message";
    }
    else if (_model.actionType == SnaNewMessageActionTypeCancelFriendship)
    {
        super.title     = @"Message";
        super.backTitle = @"Message";
    }
    else
    {
        @throw [FxException unsupportedMethodException];
    }
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)] autorelease];
    
    FxUiSection *toPersonSection = [super addSection];
    {
        if (_model.toPerson == Nil)
        {
            [toPersonSection addButtonCellWithCaption:@"Choose Friend" targetObject:self action:@selector(chooseFriend:)];
        }
        else
        {
            [toPersonSection addTextBlockCellWithCaption:@"to" boundObject:_model propertyKey:@"toPerson" displayPropertyKey:@"nick"];
        }
    }

    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextFieldCellWithPlaceholder:@"Text" boundObject:_model propertyKey:@"text"];
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testButtonsSection = [super addSection];
        {
            [testButtonsSection addButtonCellWithCaption:@"Log Out" targetObject:self action:@selector(testLogOut:)];
        }
    }
    #endif
}

- (void) chooseFriend:(id)sender
{
}
- (void) sendMessage:(id)sender
{
    if (_model.toPerson == nil)
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Friend is not selected!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else if ([_model.text isEqual:@""])
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Message body is empty!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    else
    {
        if (_model.actionType == SnaNewMessageActionTypeSendMessage)
        {
            [self.dataService sendMessageWithText:_model.text toPerson:_model.toPerson];
        }
        else if (_model.actionType == SnaNewMessageActionTypeRequestFriendship)
        {
            [self.dataService requestFriendshipToPerson:_model.toPerson withMessage:_model.text];
        }
        else if (_model.actionType == SnaNewMessageActionTypeAcceptFriendship)
        {
            [self.dataService acceptFriendshipToPerson:_model.toPerson withMessage:_model.text];
        }
        else if (_model.actionType == SnaNewMessageActionTypeRejectFriendship)
        {
            [self.dataService rejectFriendshipToPerson:_model.toPerson withMessage:_model.text];
        }
        else if (_model.actionType == SnaNewMessageActionTypeCancelFriendship)
        {
            [self.dataService cancelFriendshipToPerson:_model.toPerson withMessage:_model.text];
        }
        else
        {
            @throw [FxException unsupportedMethodException];
        }
        
        [self popViewController];
    }
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
