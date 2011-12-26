


#import "SnaChangeTargetingRangePage.h"

@implementation SnaChangeTargetingRangePageModel

@synthesize availableTargetingRanges = _availableTargetingRanges;

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) initWithTargetingRanges:(NSArray *)targetingRanges
{
    [FxAssert isNotNullArgument:targetingRanges withName:@"targetingRanges"];
    
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    _availableTargetingRanges = [targetingRanges copy];
    
    return self;
}

- (void) dealloc
{
    [_availableTargetingRanges release];
    
    [super dealloc];
}

@end
@implementation SnaChangeTargetingRangePageController

- (id) init
{
    _isInitStarted_SnaChangeTargetingRangePageController = YES;
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    [FxAssert isNotNullValue:self];
    
    _model = [[SnaChangeTargetingRangePageModel alloc] initWithTargetingRanges:self.dataService.availableTargetingRanges];
    
    return self;
}
- (id) initWithStyle:(UITableViewStyle)style
{
    if (_isInitStarted_SnaChangeTargetingRangePageController)
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
    super.title     = @"Change Targeting Range";
    super.backTitle = @"Change Targeting Range";
    
    FxUiSection *dataSection = [super addSection];
    {
        for (SnaTargetingRange *targetingRange in _model.availableTargetingRanges)
        {
            if (self.dataService.targetingRange == targetingRange)
            {
                [dataSection addItem1CellWithCaptionBoundObject:targetingRange captionPropertyKey:@"radiusInMetersAsString" contentBoundObject:nil contentPropertyKey:nil targetObject:self action:@selector(changeTargetingRange:) actionContext:targetingRange  accesoryType:UITableViewCellAccessoryCheckmark];
            }
            else
            {
                [dataSection addItem1CellWithCaptionBoundObject:targetingRange captionPropertyKey:@"radiusInMetersAsString" contentBoundObject:nil contentPropertyKey:nil targetObject:self action:@selector(changeTargetingRange:) actionContext:targetingRange  accesoryType:UITableViewCellAccessoryNone];
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

- (void) changeTargetingRange:(SnaTargetingRange *)targetingRange
{
    [self.dataService changeTargetingRange:targetingRange];
    
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
