
#import "_Domain.h"

@interface SnaVisibilityStatus()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Internal Constructor
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) _initWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end
@implementation SnaVisibilityStatus

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Enums
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+ (SnaVisibilityStatus *) INVISIBLE
{
    static SnaVisibilityStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaVisibilityStatus alloc] _initWithIdentifier:@"INVISIBLE" name:@"Invisible"];
    }
    
    return cachedResult;
}
+ (SnaVisibilityStatus *) OFFLINE
{
    static SnaVisibilityStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaVisibilityStatus alloc] _initWithIdentifier:@"OFFLINE" name:@"Offline"];
    }
    
    return cachedResult;
}
+ (SnaVisibilityStatus *) ONLINE
{    
    static SnaVisibilityStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaVisibilityStatus alloc] _initWithIdentifier:@"ONLINE" name:@"Online"];
    }
    
    return cachedResult;
}
+ (SnaVisibilityStatus *) CONTACT_ME
{
    static SnaVisibilityStatus *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = [[SnaVisibilityStatus alloc] _initWithIdentifier:@"CONTACT_ME" name:@"Contact me"];
    }
    
    return cachedResult;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Values
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

+ (NSArray *) values
{
    static NSArray *cachedResult = nil;

    if (cachedResult == nil)
    {
        cachedResult = [[NSArray alloc] initWithObjects:
            
            [SnaVisibilityStatus INVISIBLE ],
            [SnaVisibilityStatus OFFLINE   ],
            [SnaVisibilityStatus ONLINE    ],
            [SnaVisibilityStatus CONTACT_ME],
            
            nil
        ];
    }
    
    return cachedResult;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString *) name { return _name; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    @throw [FxException unsupportedMethodException];
}

- (id) _initWithIdentifier:(NSString *)identifier name:(NSString *)name;
{
    self = [super initWithIdentifier:identifier];
    
    [FxAssert isNotNullValue:self];
    
    _name = [name copy];
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_name release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
