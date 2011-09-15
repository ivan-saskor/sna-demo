
#import "SnaChangeLocationPage.h"

@implementation SnaChangeLocationPageModel

@synthesize availableLocations = _availableLocations;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithLocations:(NSArray *)locations
{
    [FxAssert isNotNullArgument:locations withName:@"locations"];

    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _availableLocations = [locations copy];
    
    return self;
}

- (void) dealloc
{
    [_availableLocations release];
    
    [super dealloc];
}

@end
@implementation SnaChangeLocationPageController

- (id) init
{
    _isInitStarted_SnaChangeLocationPageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaChangeLocationPageModel alloc] initWithLocations:self.dataService.availableLocations];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaChangeLocationPageController)
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
    super.title     = @"Change Location";
    super.backTitle = @"Change Location";
    
    FxUiSection *dataSection = [super addSection];
    {
        for (SnaLocation *location in _model.availableLocations)
        {
            if (self.dataService.currentLocation == location)
            {
                [dataSection addItem1CellWithCaptionBoundObject:location captionPropertyKey:@"name" contentBoundObject:nil contentPropertyKey:nil targetObject:self action:@selector(changeLocation:) actionContext:location  accesoryType:UITableViewCellAccessoryCheckmark];
            }
            else
            {
                [dataSection addItem1CellWithCaptionBoundObject:location captionPropertyKey:@"name" contentBoundObject:nil contentPropertyKey:nil targetObject:self action:@selector(changeLocation:) actionContext:location  accesoryType:UITableViewCellAccessoryNone];
            }

        }
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

- (void) changeLocation:(SnaLocation *)location
{
    [self.dataService changeLocation:location];
    
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
