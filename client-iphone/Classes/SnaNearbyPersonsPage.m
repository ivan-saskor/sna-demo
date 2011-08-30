
#import "SnaNearbyPersonsPage.h"

@implementation SnaNearbyPersonsPageModel

@synthesize nearbyPersons = _nearbyPersons;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithNearbyPersons:(NSArray *)nearbyPersons
{
    [FxAssert isNotNullArgument:nearbyPersons withName:@"nearbyPersons"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _nearbyPersons = [nearbyPersons copy];
    
    return self;
}

- (void) dealloc
{
    [_nearbyPersons release];
    
    [super dealloc];
}

@end
@implementation SnaNearbyPersonsPageController

- (id) init
{
    _isInitStarted_SnaNearbyPersonsPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];

    _model = [[SnaNearbyPersonsPageModel alloc] initWithNearbyPersons:self.dataService.nearbyPersons];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaNearbyPersonsPageController)
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
    super.title     = @"Nearby Persons";
    super.backTitle = @"Nearby Persons";

    FxUiSection *dataSection = [super addSection];
    {
        for (SnaPerson *person in _model.nearbyPersons)
        {
            [dataSection addItem1CellWithCaptionBoundObject:person captionPropertyKey:@"nick" contentBoundObject:person contentPropertyKey:@"mood" targetObject:self action:@selector(openPerson:) actionContext:person];
        }
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons: )];
            [testSection addButtonCellWithCaption:@"Add 5 Persons"  targetObject:self action:@selector(testAddFivePersons:)];
            [testSection addButtonCellWithCaption:@"Log Out"        targetObject:self action:@selector(testLogOut:        )];
        }
    }
    #endif
}

- (void) openPerson:(SnaPerson *)person
{
    [self showPersonPageForPerson:person];
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
