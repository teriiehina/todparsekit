//
//  TDTerminal.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTerminal.h>
#import <TDParseKit/TDAssembly.h>
#import <TDParseKit/TDToken.h>

@interface TDTerminal ()
- (TDAssembly *)matchOneAssembly:(TDAssembly *)inAssembly;
- (BOOL)qualifies:(id)obj;
- (BOOL)except:(id)obj;

@property (nonatomic, readwrite, copy) NSString *string;
@property (nonatomic, readwrite, copy) NSArray *exceptions;
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
    self.exceptions = nil;
    [super dealloc];
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSMutableSet *outAssemblies = [NSMutableSet set];
    
    for (TDAssembly *a in inAssemblies) {
        TDAssembly *b = [self matchOneAssembly:a];
        if (b) {
            [outAssemblies addObject:b];
        }
    }
    
    return outAssemblies;
}


- (TDAssembly *)matchOneAssembly:(TDAssembly *)inAssembly {
    NSParameterAssert(inAssembly);
    if (![inAssembly hasMore]) {
        return nil;
    }
    
    TDAssembly *outAssembly = nil;
    
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


- (BOOL)except:(id)obj {
    if (!exceptions) {
        return NO;
    }
    
    return [exceptions containsObject:obj];
}


- (TDTerminal *)discard {
    discardFlag = YES;
    return self;
}


- (void)setExceptions:(NSArray *)strings ignoringCase:(BOOL)ignoringCase {
    self.exceptions = strings;
    exceptIgnoringCase = ignoringCase;
}

@synthesize string;
@synthesize exceptions;
@end
