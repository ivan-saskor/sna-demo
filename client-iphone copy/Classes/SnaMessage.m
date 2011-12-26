
#import "_Domain.h"

@interface SnaMessage()

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Internal Constructor
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) _init;

@end
@implementation SnaMessage

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) id      { @throw [FxException unsupportedMethodException]; }

- (SnaPerson *) from    { @throw [FxException unsupportedMethodException]; }
- (SnaPerson *) to      { @throw [FxException unsupportedMethodException]; }

- (NSString  *) text    { @throw [FxException unsupportedMethodException]; }

- (NSDate    *) sentOn  { @throw [FxException unsupportedMethodException]; }
- (NSDate    *) readOn  { @throw [FxException unsupportedMethodException]; }

- (BOOL       ) isRead
{
    return self.readOn != nil;
}

+ (NSSet *)keyPathsForValuesAffectingIsRead
{
    return [NSSet setWithObjects:@"readOn", nil];
}

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
            
        [FxDumper dumpFieldWithName:@"id"      value  :self.id    ],

        [FxDumper dumpFieldWithName:@"from"    value  :self.from  ],
        [FxDumper dumpFieldWithName:@"to"      value  :self.to    ],
        
        [FxDumper dumpFieldWithName:@"text"    value  :self.text  ],
        
        [FxDumper dumpFieldWithName:@"sentOn"  value  :self.sentOn],
        [FxDumper dumpFieldWithName:@"readOn"  value  :self.readOn],
        
        [FxDumper dumpFieldWithName:@"isRead"  boolean:self.isRead],
        
        nil
    ];
}
- (id) copyWithZone:(NSZone *)zone
{
    if ([self class] != [SnaImmutableMessage class] || (zone != nil && self.zone != zone))
    {
        return [[SnaImmutableMessage allocWithZone:zone] initWithId:self.id
                
                                                               from:self.from
                                                                 to:self.to
                
                                                               text:self.text
                
                                                             sentOn:self.sentOn
                                                             readOn:self.readOn];
    }
    else
    {
        return [self retain];
    }
}
- (id) mutableCopyWithZone:(NSZone *)zone
{
    return [[SnaMutableMessage allocWithZone:zone] initWithId:self.id
            
                                                         from:self.from
                                                           to:self.to
            
                                                         text:self.text
            
                                                       sentOn:self.sentOn
                                                       readOn:self.readOn];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaImmutableMessage

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) id      { return _id    ; }

- (SnaPerson *) from    { return _from  ; }
- (SnaPerson *) to      { return _to    ; }

- (NSString  *) text    { return _text  ; }

- (NSDate    *) sentOn  { return _sentOn; }
- (NSDate    *) readOn  { return _readOn; }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) initWithId:(NSString  *)id

            from:(SnaPerson *)from
              to:(SnaPerson *)to

            text:(NSString  *)text

          sentOn:(NSDate    *)sentOn
          readOn:(NSDate    *)readOn
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _id      = [id        copy];
    
    _from    = [from    retain];
    _to      = [to      retain];
    
    _text    = [text      copy];
    
    _sentOn  = [sentOn    copy];
    _readOn  = [readOn    copy];
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_id      release];

    [_from    release];
    [_to      release];

    [_text    release];
    
    [_sentOn  release];
    [_readOn  release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
@implementation SnaMutableMessage

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Properties
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (NSString  *) id      { return _id    ; }

- (SnaPerson *) from    { return _from  ; }
- (SnaPerson *) to      { return _to    ; }

- (NSString  *) text    { return _text  ; }

- (NSDate    *) sentOn  { return _sentOn; }
- (NSDate    *) readOn  { return _readOn; }

- (void) setId     :(NSString  *)value
{
    [_id release];
    
    _id = [value copy];
}

- (void) setFrom   :(SnaPerson *)value
{
    [_from release];
    
    _from = [value retain];
}
- (void) setTo     :(SnaPerson *)value
{
    [_to release];
    
    _to = [value retain];
}

- (void) setText   :(NSString  *)value
{
    [_text release];
    
    _text = [value copy];
}

- (void) setSentOn :(NSDate    *)value
{
    [_sentOn release];
    
    _sentOn = [value copy];
}
- (void) setReadOn :(NSDate    *)value
{
    [_readOn release];
    
    _readOn = [value copy];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Constructors
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (id) init
{
    return [self initWithId:nil
            
                       from:nil
                         to:nil
            
                       text:nil
            
                     sentOn:nil
                     readOn:nil];
}
- (id) initWithId:(NSString  *)id

             from:(SnaPerson *)from
               to:(SnaPerson *)to

             text:(NSString  *)text

           sentOn:(NSDate    *)sentOn
           readOn:(NSDate    *)readOn
{
    self = [super _init];
    
    [FxAssert isNotNullValue:self];
    
    _id      = [id      copy  ];
    
    _from    = [from    retain];
    _to      = [to      retain];
    
    _text    = [text    copy  ];
    
    _sentOn  = [sentOn  copy  ];
    _readOn  = [readOn  copy  ];
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Infrastructure
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) dealloc
{
    [_id      release];
    
    [_from    release];
    [_to      release];

    [_text    release];
    
    [_sentOn  release];
    [_readOn  release];
    
	[super dealloc];
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@end
