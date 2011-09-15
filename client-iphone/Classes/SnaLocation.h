
#import "_Fx.h"

@class SnaPerson;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaLocation : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString  *name;

@property(nonatomic, readonly, assign) NSDecimal latitude;
@property(nonatomic, readonly, assign) NSDecimal longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private NSDecimal _latitude;
    @private NSDecimal _longitude;
}

- (id) initWithName:(NSString  *)name
           latitude:(NSDecimal  )latitude
          longitude:(NSDecimal  )longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Mutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private NSDecimal  _latitude;
    @private NSDecimal  _longitude;
}

@property(nonatomic, readwrite, copy  ) NSString  *name;

@property(nonatomic, readwrite, assign) NSDecimal  latitude;
@property(nonatomic, readwrite, assign) NSDecimal  longitude;

- (id) initWithName:(NSString  *)name
           latitude:(NSDecimal  )latitude
          longitude:(NSDecimal  )longitude;

@end
