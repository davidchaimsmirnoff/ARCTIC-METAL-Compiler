

#import <Foundation/Foundation.h>

@interface MLexer : NSObject
- (NSArray *)tokenize:(NSString *)code;
@end
