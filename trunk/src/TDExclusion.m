//
//  TDExclusion.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDExclusion.h"
#import <TDParseKit/TDAssembly.h>

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
@end

@interface TDExclusion ()
@property (nonatomic, retain, readwrite) TDParser *subparser;
@property (nonatomic, retain, readwrite) TDParser *minus;
@end

@implementation TDExclusion

+ (id)exclusionWithSubparser:(TDParser *)p minus:(TDParser *)m {
    return [[[self alloc] initWithSubparser:p minus:m] autorelease];
}


- (id)initWithSubparser:(TDParser *)p minus:(TDParser *)m {
    if (self = [super init]) {
        self.subparser = p;
        self.minus = m;
    }
    return self;
}


- (void)dealloc {
    self.subparser = nil;
    self.minus = nil;
    [super dealloc];
}


- (TDParser *)parserNamed:(NSString *)s {
    if ([name isEqualToString:s]) {
        return self;
        
        // do breadth search first
    } else if ([subparser.name isEqualToString:s]) {
        return subparser;
    } else if ([minus.name isEqualToString:s]) {
        return minus;
    } else {
        id sub = [subparser parserNamed:s];
        if (sub) {
            return sub;
        }
        sub = [minus parserNamed:s];
        if (sub) {
            return sub;
        }
    }
    return nil;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    
    NSSet *outAssemblies = [[inAssemblies copy] autorelease];
    
    outAssemblies = [subparser matchAndAssemble:outAssemblies];
    if (outAssemblies.count) {

        NSSet *negAssemblies = [[inAssemblies copy] autorelease];
        negAssemblies = [minus matchAndAssemble:negAssemblies];
        
        if (negAssemblies.count) {
            outAssemblies = [NSSet set];
        }
    }
    
    return outAssemblies;
}


@synthesize subparser;
@synthesize minus;
@end
