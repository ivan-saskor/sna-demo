
#import "SnaSignUpPage.h"

@implementation SnaSignUpPageModel

@synthesize email    = _email;
@synthesize password = _password;
@synthesize nick     = _nick;

- (id) init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _email    = @"";
    _password = @"";
    _nick     = @"";
    
    return self;
}

- (void) dealloc
{
    [_email    release];
    [_password release];
    [_nick     release];
    
    [super dealloc];
}

@end
@implementation SnaSignUpPageController

- (id) init
{
    _isInitStarted_SnaSignUpPageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaSignUpPageModel alloc] init];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaSignUpPageController)
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
    super.title     = @"Sign Up";
    super.backTitle = @"Log In";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(signUp:)] autorelease];
    
    FxUiSection *logInDataSection = [super addSection];
    {
        [logInDataSection addTextFieldCellWithPlaceholder:@"Email"    boundObject:_model propertyKey:@"email"    isEmail   :YES];
        [logInDataSection addTextFieldCellWithPlaceholder:@"Password" boundObject:_model propertyKey:@"password" isPassword:YES];
    }

    FxUiSection *nickSection = [super addSection];
    {
        [nickSection addTextFieldCellWithPlaceholder:@"Nick" boundObject:_model propertyKey:@"nick"];
    }
    
#ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Fill All Fields"     targetObject:self action:@selector(testFillAllFields:)];
            [testSection addButtonCellWithCaption:@"Fill Existing Email" targetObject:self action:@selector(testFillExistingEmail:)];
            [testSection addButtonCellWithCaption:@"Fill Existing Nick"  targetObject:self action:@selector(testFillExistingNick:)];
        }
    }
#endif
}

- (void) signUp:(id)sender
{
    BOOL isSuccesfull = [self.dataService trySignUpWithEmail:_model.email password:_model.password nick:_model.nick];
    
    if (isSuccesfull)
    {
        [self showHomePage];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Sign up failed!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

#ifdef DEBUG

- (void) testFillAllFields:(id)sender
{
    SnaPerson *newProfile = [self.dataService testGenerateNewProfile];
    
    _model.email    = newProfile.email;
    _model.password = newProfile.password;
    _model.nick     = newProfile.nick;
    
    [self refreshPage];
}
- (void) testFillExistingEmail:(id)sender
{
    _model.email = [self.dataService testGetRandomPerson].email;
    
    [self refreshPage];
}
- (void) testFillExistingNick:(id)sender
{
    _model.nick = [self.dataService testGetRandomPerson].nick;
    
    [self refreshPage];
}

#endif

@end
