//
//  TDEmpty.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDEmpty.h>

@implementation TDEmpty

+ (id)empty {
    return [[[self alloc] init] autorelease];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSSet *deepCopy = [[NSSet alloc] initWithSet:inAssemblies copyItems:YES];
    return [deepCopy autorelease];
}

@end
