//
//  PKNegation.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "PKNegation.h"
#import <ParseKit/PKAny.h>
#import <ParseKit/PKDifference.h>

@interface NSMutableSet (PKNegationAdditions)
- (void)minusSetTestingEquality:(NSSet *)s;
@end

@implementation NSMutableSet (PKNegationAdditions)

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

@interface PKNegation ()
@property (nonatomic, retain, readwrite) PKParser *subparser;
@property (nonatomic, retain) PKParser *difference;
@end

@interface PKParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@implementation PKNegation

+ (id)negationWithSubparser:(PKParser *)s {
    return [[[self alloc] initWithSubparser:s] autorelease];
}


- (id)initWithSubparser:(PKParser *)s {
    if (self = [super init]) {
        self.subparser = s;
        self.difference = [PKDifference differenceWithSubparser:[PKAny any] minus:subparser];
    }
    return self;
}


- (void)dealloc {
    self.subparser = nil;
    self.difference = nil;
    [super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    
    return [difference matchAndAssemble:inAssemblies];
}

@synthesize subparser;
@synthesize difference;
@end
