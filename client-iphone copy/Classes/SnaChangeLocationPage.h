
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaChangeLocationPageModel : NSObject

@property(nonatomic, copy) NSArray *availableLocations;

- (id) initWithLocations:(NSArray *)locations;

@end
@interface SnaChangeLocationPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaChangeLocationPageController;
    
    @private SnaChangeLocationPageModel *_model;
}
@end
