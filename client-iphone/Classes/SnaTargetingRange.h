
#import "_Fx.h"

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaTargetingRange : NSObject<NSCopying, FxIDumpableObject>

@property(nonatomic, readonly, assign) NSInteger radiusInMeters;
@property(nonatomic, readonly, copy  ) NSString  *radiusInMetersAsString;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutableTargetingRange : SnaTargetingRange
{
    @private NSInteger _radiusInMeters;
    
}

- (id) initWithRadiusInMeters:(NSInteger)radiusInMeters;

@end
