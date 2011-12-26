#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaChangeTargetingRangePageModel : NSObject

@property(nonatomic, copy) NSArray *availableTargetingRanges;

- (id) initWithTargetingRanges:(NSArray *)targetingRanges;

@end

@interface SnaChangeTargetingRangePageController : SnaTableViewPageController
{
@private BOOL _isInitStarted_SnaChangeTargetingRangePageController;
    
@private SnaChangeTargetingRangePageModel *_model;
}
@end