
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaNearbyPersonsPageModel : NSObject

@property(nonatomic, readonly) NSArray *nearbyPersons;

- (id) initWithNearbyPersons:(NSArray *)nearbyPersons;

@end
@interface SnaNearbyPersonsPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaNearbyPersonsPageController;

    @private SnaNearbyPersonsPageModel *_model;
}
@end
