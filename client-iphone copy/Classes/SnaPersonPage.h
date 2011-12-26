
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaPersonPageModel : NSObject

@property(nonatomic, readonly) SnaPerson *person;

- (id) initWithPerson:(SnaPerson *)person;

@end
@interface SnaPersonPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaPersonPageController;
    
    @private SnaPersonPageModel *_model;
}

- (id) initWithPerson:(SnaPerson *)person;

@end