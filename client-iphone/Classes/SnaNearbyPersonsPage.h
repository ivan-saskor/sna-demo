
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaNearbyPersonsPageModel : NSObject
{
    @private NSMutableArray *_nearbyPersons;
}

@property(nonatomic, readonly) NSArray *nearbyPersons;

- (id) initWithNearbyPersons:(NSArray *)nearbyPersons;

- (void) refreshNearbyPersons:(NSArray *)nearbyPersons;

@end
@interface SnaNearbyPersonsPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaNearbyPersonsPageController;

    @private SnaNearbyPersonsPageModel *_model;
}
@end
