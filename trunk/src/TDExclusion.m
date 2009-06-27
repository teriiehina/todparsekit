//
//  TDExclusion.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDExclusion.h"

@interface TDInclusion ()
- (BOOL)isPredicateMatch:(NSSet *)assemblies;
@end

@implementation TDExclusion

+ (id)exclusionWithSubparser:(TDParser *)s predicate:(TDParser *)p {
    return [[[self alloc] initWithSubparser:s predicate:p] autorelease];
}


- (void)dealloc {
    [super dealloc];
}


- (BOOL)isPredicateMatch:(NSSet *)assemblies {
    return !assemblies.count;
}

@end
