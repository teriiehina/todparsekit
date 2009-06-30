//
//  PKAlternation.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKAlternation.h>
#import <ParseKit/PKAssembly.h>

@interface PKParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation PKAlternation

+ (id)alternation {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    for (PKParser *p in subparsers) {
        [outAssemblies unionSet:[p matchAndAssemble:inAssemblies]];
    }
    
    return outAssemblies;
}

@end
