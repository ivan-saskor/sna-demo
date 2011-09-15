
#import "_Fx.h"

#import "SnaTableViewPageController.h"

@interface SnaNewMessagePageModel : NSObject

@property(nonatomic, assign, readonly) SnaNewMessageActionType actionType;

@property(nonatomic, retain, readwrite) SnaPerson *toPerson;
@property(nonatomic, copy  , readwrite) NSString  *text;

- (id) initWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text;

@end
@interface SnaNewMessagePageController : SnaTableViewPageController
{
    @private BOOL _isInitStarted_SnaNewMessagePageController;
    
    @private SnaNewMessagePageModel *_model;
}

- (id) initWithActionType:(SnaNewMessageActionType)actionType toPerson:(SnaPerson *)toPerson text:(NSString *)text;

@end
