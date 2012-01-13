
#import "_Domain.h"

@interface SnaLocation()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Internal Constructor
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) _init;

@end
@implementation SnaLocation

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) name      { @throw [FxException unsupportedMethodException]; }

- (NSDecimalNumber *) latitude  { @throw [FxException unsupportedMethodException]; }
- (NSDecimalNumber *) longitude { @throw [FxException unsupportedMethodException]; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    @throw [FxException unsupportedMethodException];
}
- (id) _init
{
    self = [super init];
    
    [FxAssert isNotNullValue:self];
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString *) description
{
    return [FxDumper dumpValue:self];
}
- (NSArray *) dumpFields
{
    return [NSArray arrayWithObjects:
            
        [FxDumper dumpFieldWithName:@"name"      value  :self.name     ],
        
        [FxDumper dumpFieldWithName:@"latitude"  decimal:self.latitude ],
        [FxDumper dumpFieldWithName:@"longitude" decimal:self.longitude],
        
        nil
    ];
}
- (id) copyWithZone:(NSZone *)zone
{
    if ([self class] != [SnaImmutableLocation class] || (zone != nil && self.zone != zone))
    {
        return [[SnaImmutableLocation allocWithZone:zone] initWithName:self.name
                
                                                              latitude:self.latitude
                                                             longitude:self.longitude];
    }
    else
    {
        return [self retain];
    }
}
- (id) mutableCopyWithZone:(NSZone *)zone
{
    return [[SnaMutableLocation allocWithZone:zone] initWithName:self.name
            
                                                        latitude:self.latitude
                                                       longitude:self.longitude];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaImmutableLocation

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) name       { return _name     ; }

- (NSDecimalNumber *  ) latitude   { return _latitude ; }
- (NSDecimalNumber *  ) longitude  { return _longitude; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) initWithName:(NSString  *)name

           latitude:(NSDecimalNumber *  )latitude
          longitude:(NSDecimalNumber *  )longitude
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _name      = [name      copy];
    
    _latitude  =  latitude       ;
    _longitude =  longitude      ;
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_name      release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaMutableLocation

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) name      { return _name     ; }

- (NSDecimalNumber *  ) latitude  { return _latitude ; }
- (NSDecimalNumber * ) longitude { return _longitude; }

- (void) setName     :(NSString  *)value
{
    [_name release];
    
    _name = [value copy];
}

- (void) setLatitude :(NSDecimalNumber *  )value
{
    _latitude = value;
}
- (void) setLongitude:(NSDecimalNumber *  )value
{
    _longitude = value;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    return [self initWithName:nil
            
                     latitude:[NSDecimalNumber decimalNumberWithString:@"0"]
                    longitude:[NSDecimalNumber decimalNumberWithString:@"0"]];
}
- (id) initWithName:(NSString  *)name
           latitude:(NSDecimalNumber *  )latitude
          longitude:(NSDecimalNumber *  )longitude
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _name      = [name       copy];
    
    _latitude  =  latitude        ;
    _longitude =  longitude       ;
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_name    release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
