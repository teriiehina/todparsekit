//
//  TDInclusion.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDInclusion.h"
#import <TDParseKit/TDAssembly.h>

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;
@end

@interface TDInclusion ()
- (BOOL)isPredicateMatch:(NSSet *)assemblies;

@property (nonatomic, retain, readwrite) TDParser *subparser;
@property (nonatomic, retain, readwrite) TDParser *predicate;
@end

@implementation TDInclusion

+ (id)inclusionWithSubparser:(TDParser *)s predicate:(TDParser *)p {
    return [[[self alloc] initWithSubparser:s predicate:p] autorelease];
}


- (id)initWithSubparser:(TDParser *)s predicate:(TDParser *)p {
    if (self = [super init]) {
        self.subparser = s;
        self.predicate = p;
    }
    return self;
}


- (void)dealloc {
    self.subparser = nil;
    self.predicate = nil;
    [super dealloc];
}


- (TDParser *)parserNamed:(NSString *)s {
    if ([name isEqualToString:s]) {
        return self;
        
        // do breadth-first search
    } else if ([subparser.name isEqualToString:s]) {
        return subparser;
    } else if ([predicate.name isEqualToString:s]) {
        return predicate;
    } else {
        id sub = [subparser parserNamed:s];
        if (sub) {
            return sub;
        }
        sub = [predicate parserNamed:s];
        if (sub) {
            return sub;
        }
    }
    return nil;
}


- (BOOL)isPredicateMatch:(NSSet *)assemblies {
    return assemblies.count;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSSet *outAssemblies = [[inAssemblies copy] autorelease];
    
    outAssemblies = [subparser matchAndAssemble:outAssemblies];
    if (outAssemblies.count) {
        NSSet *predAssemblies = [[inAssemblies copy] autorelease];
        predAssemblies = [predicate allMatchesFor:predAssemblies];

        if (![self isPredicateMatch:predAssemblies]) {
            outAssemblies = [NSSet set];
        }
        
//        if (!predAssemblies.count) {
//            outAssemblies = [NSSet set];
//        }
    }
    
    return outAssemblies;
}

@synthesize subparser;
@synthesize predicate;
@end
