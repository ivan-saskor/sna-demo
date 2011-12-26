
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
    
    super.title = @"Profile";

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
    super.backTitle = @"Profile";

    [super addPageRefreshTriggerWithBoundObject:[self dataService] propertyKey:@"timestamp"];

    FxUiSection *dataSection = [super addSection];
    {
        [dataSection addTextBlockCellWithCaption:@"nick"  boundObject:_model.currentUser propertyKey:@"nick" ];
        [dataSection addTextBlockCellWithCaption:@"mood"  boundObject:_model.currentUser propertyKey:@"mood" ];
    }
    FxUiSection *changeMoodButtonSection = [super addSection];
    {
        [changeMoodButtonSection addButtonCellWithCaption:@"Change Mood" targetObject:self action:@selector(openChangeMoodPage:)];
    }
    FxUiSection *rangeSection = [super addSection];
    {
        [rangeSection addTextBlockCellWithCaption:@"range"  boundObject:self.dataService.targetingRange propertyKey:@"radiusInMetersAsString" ];
    }
    FxUiSection *changeRangeSection = [super addSection];
    {
        [changeRangeSection addButtonCellWithCaption:@"Change Range" targetObject:self action:@selector(openChangeRangePage:)];
    }
    FxUiSection *mainDataSection = [super addSection];
    {
        [mainDataSection addTextBlockCellWithCaption:@"born on"     boundObject:_model.currentUser propertyKey:@"bornOnAsString"            ];
        [mainDataSection addTextBlockCellWithCaption:@"gender"      boundObject:_model.currentUser propertyKey:@"gender"                    displayPropertyKey:@"name"];
        [mainDataSection addTextBlockCellWithCaption:@"looking for" boundObject:_model.currentUser propertyKey:@"lookingForGendersAsString" ];
    }
    FxUiSection *otherDataSection = [super addSection];
    {
        [otherDataSection addTextBlockCellWithCaption:@"description"   boundObject:_model.currentUser propertyKey:@"myDescription"];
        [otherDataSection addTextBlockCellWithCaption:@"occupation"    boundObject:_model.currentUser propertyKey:@"occupation"   ];
        [otherDataSection addTextBlockCellWithCaption:@"hobby"         boundObject:_model.currentUser propertyKey:@"hobby"        ];
        [otherDataSection addTextBlockCellWithCaption:@"main location" boundObject:_model.currentUser propertyKey:@"mainLocation" ];
    }
    FxUiSection *contactsDataSection = [super addSection];
    {
        [contactsDataSection addTextBlockCellWithCaption:@"email" boundObject:_model.currentUser propertyKey:@"email"];
        [contactsDataSection addTextBlockCellWithCaption:@"phone" boundObject:_model.currentUser propertyKey:@"phone"];
    }
    FxUiSection *locationSection = [super addSection];
    {
        [locationSection addTextBlockCellWithCaption:@"current location" boundObject:self.dataService propertyKey:@"currentLocation" displayPropertyKey:@"name"];
    }
    FxUiSection *changeLocationButtonSection = [super addSection];
    {
        [changeLocationButtonSection addButtonCellWithCaption:@"Change Location" targetObject:self action:@selector(openChangeLocationPage:)];
    }
    FxUiSection *buttonsSection = [super addSection];
    {
        [buttonsSection addButtonCellWithCaption:@"Log Out"     targetObject:self action:@selector(logOut:             )];
    }
    
    #ifdef DEBUG
    {
        FxUiSection *testSection = [super addSectionWithCaption:@"Test"];
        {
            [testSection addButtonCellWithCaption:@"Mutate Persons" targetObject:self action:@selector(testMutatePersons:)];
            [testSection addButtonCellWithCaption:@"Mutate targeting range" targetObject:self action:@selector(testMutateTargetingRange:)];
        }
    }
    #endif
}

- (void) openChangeMoodPage:(id) sender
{
    [self showChangeMoodPage];
}
- (void) openChangeLocationPage:(id) sender
{
    [self showChangeLocationPage];
}
-  (void) openChangeRangePage:(id) sender
{
    [self showChangeTargetingRangePage];
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

- (void) testMutateTargetingRange:(id)sender
{
    [self.dataService testMutateTargetRange];
}

#endif

@end
