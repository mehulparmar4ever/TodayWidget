//
//  NSDictionary+Additions.m
//

#import "NSDictionary+Additions.h"

@implementation NSArray (Additions)

- (NSArray *) arrayByReplacingNullsWithStrings {
    
    NSMutableArray *replaced = [NSMutableArray arrayWithArray: self];
    const NSString *blank = @"";
    

    [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
       
        if ([object isEqual:[NSNull null]]) {
            [replaced replaceObjectAtIndex:idx withObject:blank];
        }
        else if ([object isEqual:@"<null>"]) {
            [replaced replaceObjectAtIndex:idx withObject:blank];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithStrings]];
        }
        else if ([object isKindOfClass: [NSArray class]]) {
            
            [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithStrings]];
        }

    }];

    return [NSArray arrayWithArray:replaced];
}

- (NSArray *) arrayByConvertingNumbersToStrings {
    
    NSMutableArray *replaced = [NSMutableArray arrayWithArray: self];
    const NSString *blank = @"";
    
    
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        
        if ([object isEqual:[NSNull null]]) {
            [replaced replaceObjectAtIndex:idx withObject:blank];
        }
        else if ([object isEqual:@"<null>"]) {
            [replaced replaceObjectAtIndex:idx withObject:blank];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByConvertingNumbersToStrings]];
        }
        else if ([object isKindOfClass: [NSArray class]]) {
            
            [replaced replaceObjectAtIndex:idx withObject:[object arrayByConvertingNumbersToStrings]];
        }
        
    }];
    
    return [NSArray arrayWithArray:replaced];
}

@end

@implementation NSDictionary (Additions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];

    const NSString *blank = @"";
    const id nul = [NSNull null];
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {            // do something with null JSON value here
            [replaced setObject: blank forKey: key];
        }
        else if ([object isEqual:[NSNull null]]) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isEqual:@"<null>"]) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
        else if ([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [object arrayByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

- (NSDictionary *) dictionaryByConvertingNumbersToStrings {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if ([object isKindOfClass:[NSNumber class]]) {
            [replaced setObject: [object stringValue] forKey: key];
        }
        else if ([object isEqual:@"<null>"]) {
            [replaced setObject: @"" forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByConvertingNumbersToStrings] forKey: key];
        }
        else if ([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [object arrayByConvertingNumbersToStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

@end
