
#import <Foundation/Foundation.h>

@interface FxStringTools : NSObject

+ (NSString *)EMPTY_STRING;
+ (NSString *)QUOTATION;
+ (NSString *)NEW_LINE;
+ (NSString *)INDENTATION;

+ (NSString *)quoteValue:(NSObject *)value;

+ (NSString *)joinValues:(NSArray *)values;
+ (NSString *)joinValues:(NSArray *)values withDelimiter:(NSString *)delimiter;

+ (NSArray *)splitString:(NSString *)string onDelimiter:(NSString *)delimiter;

+ (NSString *)indentString:(NSString *)string;

@end
