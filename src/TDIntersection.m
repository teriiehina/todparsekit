//
//  TDIntersection.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDIntersection.h"
#import <ParseKit/PKAssembly.h>

@interface NSMutableSet (TDIntersectionAdditions)
- (void)intersectSetTestingEquality:(NSSet *)s;
@end

@implementation NSMutableSet (TDIntersectionAdditions)

- (void)intersectSetTestingEquality:(NSSet *)s {
    for (id a1 in self) {
        BOOL found = NO;
        for (id a2 in s) {
            if ([a1 isEqualTo:a2 ]) {
                found = YES;
                break;
            }
        }
        if (!found) {
            [self removeObject:a1];
        }
    }
}

@end

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation TDIntersection

+ (id)intersection {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    NSInteger i = 0;
    for (TDParser *p in subparsers) {
        if (0 == i++) {
            outAssemblies = [[[p matchAndAssemble:inAssemblies] mutableCopy] autorelease];
        } else {
            [outAssemblies intersectSetTestingEquality:[p allMatchesFor:inAssemblies]];
        }
    }
    
    return outAssemblies;
}

@end
