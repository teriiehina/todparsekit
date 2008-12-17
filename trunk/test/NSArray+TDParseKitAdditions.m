//
//  NSArray+TDParseKitAdditions.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "NSArray+TDParseKitAdditions.h"

@implementation NSArray (TDParseKitAdditions)

- (NSArray *)reversedArray {
    return [[[self reversedMutableArray] copy] autorelease];
}


- (NSMutableArray *)reversedMutableArray {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *e = [self reverseObjectEnumerator];
    id obj = nil;
    while (obj = [e nextObject]) {
        [result addObject:obj];
    }
    return result;
}

@end
