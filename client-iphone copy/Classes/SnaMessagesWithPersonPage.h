
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaMessagesWithPersonPageModel : NSObject

@property(nonatomic, readonly) SnaPerson *person;

- (id) initWithPerson:(SnaPerson *)person;

@end
@interface SnaMessagesWithPersonPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaMessagesWithPersonPageController;
    
    @private SnaMessagesWithPersonPageModel *_model;
}
@end
