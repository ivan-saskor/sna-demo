
#import "_Fx.h"

@class SnaPerson;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaLocation : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString  *name;

@property(nonatomic, readonly, assign) double latitude;
@property(nonatomic, readonly, assign) double longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private double _latitude;
    @private double _longitude;
}

- (id) initWithName:(NSString  *)name
           latitude:(double)latitude
          longitude:(double)longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Mutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private double _latitude;
    @private double  _longitude;
}

@property(nonatomic, readwrite, copy  ) NSString  *name;

@property(nonatomic, readwrite, assign) double  latitude;
@property(nonatomic, readwrite, assign) double  longitude;

- (id) initWithName:(NSString  *)name
           latitude:(double)latitude
          longitude:(double)longitude;

@end
