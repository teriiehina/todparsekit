//
//  TDTerminal.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDTerminal.h>
#import <ParseKit/PKAssembly.h>
#import <ParseKit/TDToken.h>

@interface TDTerminal ()
- (PKAssembly *)matchOneAssembly:(PKAssembly *)inAssembly;
- (BOOL)qualifies:(id)obj;

@property (nonatomic, readwrite, copy) NSString *string;
@end

@implementation TDTerminal

- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    if (self = [super init]) {
        self.string = s;
    }
    return self;
}


- (void)dealloc {
    self.string = nil;
    [super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    for (PKAssembly *a in inAssemblies) {
        PKAssembly *b = [self matchOneAssembly:a];
        if (b) {
            [outAssemblies addObject:b];
        }
    }
    
    return outAssemblies;
}


- (PKAssembly *)matchOneAssembly:(PKAssembly *)inAssembly {
    NSParameterAssert(inAssembly);
    if (![inAssembly hasMore]) {
        return nil;
    }
    
    PKAssembly *outAssembly = nil;
    
    if ([self qualifies:[inAssembly peek]]) {
        outAssembly = [[inAssembly copy] autorelease];
        id obj = [outAssembly next];
        if (!discardFlag) {
            [outAssembly push:obj];
        }
    }
    
    return outAssembly;
}


- (BOOL)qualifies:(id)obj {
    NSAssert1(0, @"-[TDTerminal %s] must be overriden", _cmd);
    return NO;
}


- (TDTerminal *)discard {
    discardFlag = YES;
    return self;
}

@synthesize string;
@end
