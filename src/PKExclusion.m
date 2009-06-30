//
//  PKExclusion.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKExclusion.h"

@interface NSMutableSet (TDExclusionAdditions)
- (void)minusSetTestingEquality:(NSSet *)s;
@end

@implementation NSMutableSet (TDExclusionAdditions)

- (void)minusSetTestingEquality:(NSSet *)s {
    for (id a1 in self) {
        for (id a2 in s) {
            if ([a1 isEqualTo:a2 ]) {
                [self removeObject:a1];
            }
        }
    }
}

@end

@interface PKParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation PKExclusion

+ (id)exclusion {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = nil;
    
    NSInteger i = 0;
    for (PKParser *p in subparsers) {
        if (0 == i++) {
            outAssemblies = [[[p matchAndAssemble:inAssemblies] mutableCopy] autorelease];
        } else {
            [outAssemblies minusSetTestingEquality:[p allMatchesFor:inAssemblies]];
        }
    }
    
    return outAssemblies;
}

@end
