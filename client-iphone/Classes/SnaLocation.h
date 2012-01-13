
#import "_Fx.h"

@class SnaPerson;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Read-only Abstract
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaLocation : NSObject<NSCopying, NSMutableCopying, FxIDumpableObject>

@property(nonatomic, readonly, copy  ) NSString  *name;

@property(nonatomic, readonly, assign) NSDecimalNumber * latitude;
@property(nonatomic, readonly, assign) NSDecimalNumber * longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Immutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaImmutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private NSDecimalNumber * _latitude;
    @private NSDecimalNumber * _longitude;
}

- (id) initWithName:(NSString  *)name
           latitude:(NSDecimalNumber *  )latitude
          longitude:(NSDecimalNumber *  )longitude;

@end

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Mutable
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface SnaMutableLocation : SnaLocation
{
    @private NSString  *_name;
        
    @private NSDecimalNumber *  _latitude;
    @private NSDecimalNumber *  _longitude;
}

@property(nonatomic, readwrite, copy  ) NSString  *name;

@property(nonatomic, readwrite, assign) NSDecimalNumber *  latitude;
@property(nonatomic, readwrite, assign) NSDecimalNumber *  longitude;

- (id) initWithName:(NSString  *)name
           latitude:(NSDecimalNumber *  )latitude
          longitude:(NSDecimalNumber *  )longitude;

@end
