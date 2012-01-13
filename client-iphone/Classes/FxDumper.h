
#import <Foundation/Foundation.h>

@interface FxDumper : NSObject

+ (NSString *)dumpValue:(NSObject *)value;

+ (NSString *)dumpFieldWithName:(NSString *)name value  :(NSObject *)value;
+ (NSString *)dumpFieldWithName:(NSString *)name boolean:(BOOL      )value;
+ (NSString *)dumpFieldWithName:(NSString *)name integer:(NSInteger )value;
+ (NSString *)dumpFieldWithName:(NSString *)name decimal:(double)value;

@end
