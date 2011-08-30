
#import "SnaLogInPage.h"

@implementation SnaLogInPageModel

@synthesize email    = _email;
@synthesize password = _password;

- (id) init
{
    return [self initWithEmail:nil password:nil];
}
- (id) initWithEmail:(NSString *)email password:(NSString *)password
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _email    = email;
    _password = password;
    
    return self;
}

- (void) dealloc
{
    [_email    release];
    [_password release];
    
    [super dealloc];
}

@end
@implementation SnaLogInPageController

- (id) init
{
    _isInitStarted_SnaLogInPageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaLogInPageModel alloc] initWithEmail:self.dataService.defaultLogInEmail 
                                             password:self.dataService.defaultLogInPassword];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaLogInPageController)
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
    super.backTitle = @"Log In";

    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextFieldCellWithPlaceholder:@"Email"    boundObject:_model propertyKey:@"email"    isEmail   :YES];
        [dataSection addTextFieldCellWithPlaceholder:@"Password" boundObject:_model propertyKey:@"password" isPassword:YES];
    }
    FxUiSection *buttonsSection = [super addSection];
    {
        [buttonsSection addButtonCellWithCaption:@"Log In" targetObject:self action:@selector(logIn:)];
    }

    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Log In Person A"      targetObject:self action:@selector(testLogInPersonA:     )];
            [testSection addButtonCellWithCaption:@"Log In Person B"      targetObject:self action:@selector(testLogInPersonB:     )];
            [testSection addButtonCellWithCaption:@"Log In Random Person" targetObject:self action:@selector(testLogInRandomPerson:)];
        }
    }
    #endif
}

- (void) logIn:(id)sender
{
    [self.dataService logInWithEmail:_model.email password:_model.password];

    [self showHomePage];
}

#ifdef DEBUG

- (void) testLogInPersonA:(id)sender
{
    [self.dataService testLogInPersonA];
    
    [self showHomePage];
}
- (void) testLogInPersonB:(id)sender
{
    [self.dataService testLogInPersonB];
    
    [self showHomePage];
}
- (void) testLogInRandomPerson:(id)sender
{
    [self.dataService testLogInRandomPerson];
    
    [self showHomePage];
}

#endif

@end
