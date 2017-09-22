//
//  NSDictionary+Additions.h
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSArray *) arrayByReplacingNullsWithStrings;
- (NSArray *) arrayByConvertingNumbersToStrings;

@end

@interface NSDictionary (Additions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings;
- (NSDictionary *) dictionaryByConvertingNumbersToStrings;

@end
