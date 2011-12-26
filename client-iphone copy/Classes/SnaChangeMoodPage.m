
#import "SnaChangeMoodPage.h"

@implementation SnaChangeMoodPageModel

@synthesize mood = _mood;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithMood:(NSString *)mood
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _mood = [mood copy];
    
    return self;
}

- (void) dealloc
{
    [_mood release];
    
    [super dealloc];
}

@end
@implementation SnaChangeMoodPageController

- (id) init
{
    _isInitStarted_SnaChangeMoodPageController = YES;
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaChangeMoodPageModel alloc] initWithMood:self.dataService.currentUser.mood];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaChangeMoodPageController)
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
    super.title     = @"Change Mood";
    super.backTitle = @"Change Mood";
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(changeMood:)] autorelease];
    
    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextFieldCellWithPlaceholder:@"Mood" boundObject:_model propertyKey:@"mood"];
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

- (void) changeMood:(id)sender
{
    [self.dataService changeMood:_model.mood];
    
    [self popViewController];
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
