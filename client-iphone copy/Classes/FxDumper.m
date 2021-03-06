
#import "FxDumper.h"

#import "FxIDumpableObject.h"
#import "FxIDumpableEnum.h"
#import "FxStringTools.h"

@interface FxDumper()

+ (NSString *)_FIELD_LIST_START_DELIMITER;
+ (NSString *)_FIELD_LIST_END_DELIMITER;

+ (NSString *)_FIELD_NAME_VALUE_DELIMITER;

+ (NSString *)_ENUM_CLASS_IDENTIFIER_DELIMITER;

+ (NSString *)_ARRAY_LIST_START_DELIMITER;
+ (NSString *)_ARRAY_LIST_END_DELIMITER;

+ (NSString *)_dumpDumpableObject:(NSObject<FxIDumpableObject> *)dumpableObject;
+ (NSString *)_dumpDumpableEnum  :(NSObject<FxIDumpableEnum>   *)dumpableEnum;
+ (NSString *)_dumpArray         :(NSArray                     *)array;
+ (NSString *)_dumpString        :(NSString                    *)string;
+ (NSString *)_dumpBoolean       :(BOOL                         )boolean;
+ (NSString *)_dumpInteger       :(NSInteger                    )integer;
+ (NSString *)_dumpDecimal       :(NSDecimal                    )decimal;

+ (NSString *)_dumpClassNameAndMemoryAddressOfObject:(NSObject*)object;

@end
@implementation FxDumper

+ (NSString *)_FIELD_LIST_START_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"{";
    }
    
    return cachedResult;
}
+ (NSString *)_FIELD_LIST_END_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"}";
    }
    
    return cachedResult;
}

+ (NSString *)_FIELD_NAME_VALUE_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @" : ";
    }
    
    return cachedResult;
}

+ (NSString *)_ENUM_CLASS_IDENTIFIER_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @".";
    }
    
    return cachedResult;
}

+ (NSString *)_ARRAY_LIST_START_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"[";
    }
    
    return cachedResult;
}
+ (NSString *)_ARRAY_LIST_END_DELIMITER
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"]";
    }
    
    return cachedResult;
}

+ (NSString *)dumpValue:(NSObject *)value
{
    if ([value conformsToProtocol:@protocol(FxIDumpableObject)])
    {
        return [FxDumper _dumpDumpableObject:(NSObject<FxIDumpableObject> *)value];
    }
    if ([value conformsToProtocol:@protocol(FxIDumpableEnum)])
    {
        return [FxDumper _dumpDumpableEnum:(NSObject<FxIDumpableEnum> *)value];
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return [FxDumper _dumpArray:(NSArray *)value];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [FxDumper _dumpString:(NSString *)value];
    }
    
    @throw [NSException exceptionWithName:@"Value type is not supported" reason:nil userInfo:nil];
}

+ (NSString *)dumpFieldWithName:(NSString *)name value  :(NSObject *)value
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            name,
            [FxDumper dumpValue:value],
            nil
        ]
        withDelimiter:FxDumper._FIELD_NAME_VALUE_DELIMITER
    ];
}
+ (NSString *)dumpFieldWithName:(NSString *)name boolean:(BOOL      )value
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            name,
            [FxDumper _dumpBoolean:value],
            nil
        ]
        withDelimiter:FxDumper._FIELD_NAME_VALUE_DELIMITER
    ];
}
+ (NSString *)dumpFieldWithName:(NSString *)name integer:(NSInteger )value
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            name,
            [FxDumper _dumpInteger:value],
            nil
        ]
        withDelimiter:FxDumper._FIELD_NAME_VALUE_DELIMITER
    ];
}
+ (NSString *)dumpFieldWithName:(NSString *)name decimal:(NSDecimal )value
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            name,
            [FxDumper _dumpDecimal:value],
            nil
        ]
        withDelimiter:FxDumper._FIELD_NAME_VALUE_DELIMITER
    ];
}

+ (NSString *)_dumpDumpableObject:(NSObject<FxIDumpableObject> *)dumpableObject
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            [FxDumper _dumpClassNameAndMemoryAddressOfObject:dumpableObject],
            FxDumper._FIELD_LIST_START_DELIMITER,
            [FxStringTools indentString:[FxStringTools joinValues:[dumpableObject dumpFields] withDelimiter:FxStringTools.NEW_LINE]],
            FxDumper._FIELD_LIST_END_DELIMITER,
            nil
        ]
        withDelimiter:FxStringTools.NEW_LINE
    ];
}
+ (NSString *)_dumpDumpableEnum  :(NSObject<FxIDumpableEnum>   *)dumpableEnum
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            [dumpableEnum class],
            [dumpableEnum dumpIdentifier],
            nil
        ]
        withDelimiter:FxDumper._ENUM_CLASS_IDENTIFIER_DELIMITER
    ];
}
+ (NSString *)_dumpArray         :(NSArray                    *)array
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            [FxDumper _dumpClassNameAndMemoryAddressOfObject:array],
            FxDumper._ARRAY_LIST_START_DELIMITER,
            [FxStringTools indentString:[FxStringTools joinValues:array withDelimiter:FxStringTools.NEW_LINE]],
            FxDumper._ARRAY_LIST_END_DELIMITER,
            nil
        ]
        withDelimiter:FxStringTools.NEW_LINE
    ];
}
+ (NSString *)_dumpString        :(NSString                   *)string
{
    return [FxStringTools quoteValue:string];
}
+ (NSString *)_dumpBoolean       :(BOOL                        )boolean
{
    return boolean ? @"YES" : @"NO";
}
+ (NSString *)_dumpInteger       :(NSInteger                   )integer
{
    return [NSString stringWithFormat:@"%d", integer];
}
+ (NSString *)_dumpDecimal       :(NSDecimal                   )decimal
{
    return [[NSDecimalNumber decimalNumberWithDecimal:decimal] description];
}

+ (NSString *)_dumpClassNameAndMemoryAddressOfObject:(NSObject*)object
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            [object class],
            @" <",
            [NSString stringWithFormat:@"%p", object],
            @">",
            nil
        ]
    ];
}

@end
