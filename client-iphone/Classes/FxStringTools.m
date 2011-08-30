
#import "FxStringTools.h"

@interface FxStringTools()

+ (NSArray *) _indentLines:(NSArray *)lines;
+ (NSString *) _indentLine:(NSString *)line;

@end
@implementation FxStringTools

+ (NSString *)EMPTY_STRING
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"";
    }
    
    return cachedResult;
}
+ (NSString *)QUOTATION
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"\"";
    }
    
    return cachedResult;
}
+ (NSString *)NEW_LINE
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"\n";
    }
    
    return cachedResult;
}
+ (NSString *)INDENTATION
{
    static NSString *cachedResult = nil;
    
    if (cachedResult == nil)
    {
        cachedResult = @"    ";
    }
    
    return cachedResult;
}

+ (NSString *)quoteValue:(NSObject *)value
{
    return [FxStringTools joinValues:[NSArray arrayWithObjects:FxStringTools.QUOTATION, value, FxStringTools.QUOTATION, nil]];
}

+ (NSString *)joinValues:(NSArray *)values
{
    return [FxStringTools joinValues:values withDelimiter:FxStringTools.EMPTY_STRING];
}
+ (NSString *)joinValues:(NSArray *)values withDelimiter:(NSString *)delimiter
{
    return [values componentsJoinedByString:delimiter];
}

+ (NSArray *)splitString:(NSString *)string onDelimiter:(NSString *)delimiter
{
    return [string componentsSeparatedByString:delimiter];
}

+ (NSString *)indentString:(NSString *)string
{
    NSArray *lines = [FxStringTools splitString:string onDelimiter:FxStringTools.NEW_LINE];
    NSArray *indentedlines = [FxStringTools _indentLines:lines];
    
    return [FxStringTools joinValues:indentedlines withDelimiter:FxStringTools.NEW_LINE];
}

+ (NSArray *) _indentLines:(NSArray *)lines
{
    NSMutableArray *resultBuilder = [NSMutableArray array];
    
    for (NSString *line in lines)
    {
        [resultBuilder addObject:[FxStringTools _indentLine:line]];
    }

    return [resultBuilder copy];
}
+ (NSString *) _indentLine:(NSString *)line
{
    return [FxStringTools
        joinValues:[NSArray arrayWithObjects:
            FxStringTools.INDENTATION,
            line,
            nil
        ]
    ];
}
@end
