
#import "SnaProfilePage.h"

@implementation SnaProfilePageModel

@synthesize currentUser = _currentUser;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithCurrentUser:(SnaPerson *)currentUser
{
    [FxAssert isNotNullArgument:currentUser withName:@"currentUser"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _currentUser = [currentUser retain];
    
    return self;
}

- (void) dealloc
{
    [_currentUser release];
    
    [super dealloc];
}

@end
@implementation SnaProfilePageController

- (id) init
{
    _isInitStarted_SnaProfilePageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaProfilePageModel alloc] initWithCurrentUser:self.dataService.currentUser];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaProfilePageController)
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
    super.title     = @"Profile";
    super.backTitle = @"Profile";
    
    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextBlockCellWithCaption:@"nick" boundObject:_model.currentUser propertyKey:@"nick"];
        [dataSection addTextBlockCellWithCaption:@"mood" boundObject:_model.currentUser propertyKey:@"mood"];
    }
    FxUiSection *buttonsSection = [super addSection];
    {
        [buttonsSection addButtonCellWithCaption:@"Change Mood"    targetObject:self action:@selector(openChangeMoodPopup:)];
        [buttonsSection addButtonCellWithCaption:@"Log Out"        targetObject:self action:@selector(logOut:             )];
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons:)];
        }
    }
    #endif
}

- (void) openChangeMoodPopup:(id)sender
{
}

- (void) logOut:(id)sender
{
    [self removeAllPageRefreshTriggers];
    
    [self.dataService logOut];
    
    [self showLogInPage];
}

- (void) dealloc
{
    [_model release];

    [super dealloc];
}

#ifdef DEBUG

- (void) testMutatePersons:(id)sender
{
    [self.dataService testMutatePersons];
}

#endif

@end
