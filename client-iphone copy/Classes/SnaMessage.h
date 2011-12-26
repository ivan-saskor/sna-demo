
#import "_Fx.h"

@class SnaPerson;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMessage : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString  *id;

@property(nonatomic, readonly, retain) SnaPerson *from;
@property(nonatomic, readonly, retain) SnaPerson *to;

@property(nonatomic, readonly, copy  ) NSString  *text;

@property(nonatomic, readonly, copy  ) NSDate    *sentOn;
@property(nonatomic, readonly, copy  ) NSDate    *readOn;

@property(nonatomic, readonly, assign) BOOL       isRead; // CALCULATED

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutableMessage : SnaMessage
{
    @private NSString  *_id;

    @private SnaPerson *_from;
    @private SnaPerson *_to;

    @private NSString  *_text;

    @private NSDate    *_sentOn;
    @private NSDate    *_readOn;
}

- (id) initWithId:(NSString  *)id

             from:(SnaPerson *)from
               to:(SnaPerson *)to

             text:(NSString  *)text

           sentOn:(NSDate    *)sentOn
           readOn:(NSDate    *)readOn;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Mutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMutableMessage : SnaMessage
{
    @private NSString  *_id;
        
    @private SnaPerson *_from;
    @private SnaPerson *_to;

    @private NSString  *_text;
        
    @private NSDate    *_sentOn;
    @private NSDate    *_readOn;
}

@property(nonatomic, readwrite, copy  ) NSString  *id;

@property(nonatomic, readwrite, retain) SnaPerson *from;
@property(nonatomic, readwrite, retain) SnaPerson *to;

@property(nonatomic, readwrite, copy  ) NSString  *text;

@property(nonatomic, readwrite, copy  ) NSDate    *sentOn;
@property(nonatomic, readwrite, copy  ) NSDate    *readOn;

- (id) initWithId:(NSString  *)id

             from:(SnaPerson *)from
               to:(SnaPerson *)to

             text:(NSString  *)text

           sentOn:(NSDate    *)sentOn
           readOn:(NSDate    *)readOn;

@end
