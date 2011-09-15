
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaFriendshipRequestsPageModel : NSObject
{
    @private NSArray *_waitingForMePersons;
    @private NSArray *_waitingForHimPersons;
    @private NSArray *_rejectedPersons;
}

@property(nonatomic, readonly) NSArray *waitingForMePersons;
@property(nonatomic, readonly) NSArray *waitingForHimPersons;
@property(nonatomic, readonly) NSArray *rejectedPersons;

- (id) initWithWaitingForMePersons:(NSArray *)waitingForMePersons
              waitingForHimPersons:(NSArray *)waitingForHimPersons
                   rejectedPersons:(NSArray *)rejectedPersons;

@end
@interface SnaFriendshipRequestsPageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaFriendshipRequestsPageController;
    
    @private SnaFriendshipRequestsPageModel *_model;
}
@end
