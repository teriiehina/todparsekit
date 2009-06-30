//
//  TDParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDParser.h>
#import <ParseKit/TDAssembly.h>
#import <ParseKit/TDTokenAssembly.h>
#import <ParseKit/TDTokenizer.h>

@interface TDParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (TDAssembly *)best:(NSSet *)inAssemblies;
@end

@interface TDParser (TDParserFactoryAdditionsFriend)
- (void)setTokenizer:(TDTokenizer *)t;
@end

@implementation TDParser

+ (id)parser {
    return [[[self alloc] init] autorelease];
}


- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (void)dealloc {
    assembler = nil;
    self.selector = nil;
    self.name = nil;
    if (tokenizer) {
        self.tokenizer = nil;
    }
    [super dealloc];
}


- (void)setAssembler:(id)a selector:(SEL)sel {
    self.assembler = a;
    self.selector = sel;
}


- (TDParser *)parserNamed:(NSString *)s {
    if ([name isEqualToString:s]) {
        return self;
    }
    return nil;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSAssert1(0, @"-[TDParser %s] must be overriden", _cmd);
    return nil;
}


- (TDAssembly *)bestMatchFor:(TDAssembly *)a {
    NSParameterAssert(a);
    NSSet *initialState = [NSSet setWithObject:a];
    NSSet *finalState = [self matchAndAssemble:initialState];
    return [self best:finalState];
}


- (TDAssembly *)completeMatchFor:(TDAssembly *)a {
    NSParameterAssert(a);
    TDAssembly *best = [self bestMatchFor:a];
    if (best && ![best hasMore]) {
        return best;
    }
    return nil;
}


- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    NSSet *outAssemblies = [self allMatchesFor:inAssemblies];
    if (assembler) {
        NSAssert2([assembler respondsToSelector:selector], @"provided assembler %@ should respond to %s", assembler, selector);
        for (TDAssembly *a in outAssemblies) {
            [assembler performSelector:selector withObject:a];
        }
    }
    return outAssemblies;
}


- (TDAssembly *)best:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    TDAssembly *best = nil;
    
    for (TDAssembly *a in inAssemblies) {
        if (![a hasMore]) {
            best = a;
            break;
        }
        if (!best || a.objectsConsumed > best.objectsConsumed) {
            best = a;
        }
    }
    
    return best;
}


- (NSString *)description {
    NSString *className = [[self className] substringFromIndex:2];
    if (name.length) {
        return [NSString stringWithFormat:@"%@ (%@)", className, name];
    } else {
        return [NSString stringWithFormat:@"%@", className];
    }
}

@synthesize assembler;
@synthesize selector;
@synthesize name;
@end

@implementation TDParser (TDParserFactoryAdditions)

- (id)parse:(NSString *)s {
    TDTokenizer *t = self.tokenizer;
    if (!t) {
        t = [TDTokenizer tokenizer];
    }
    t.string = s;
    TDAssembly *a = [self completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    if (a.target) {
        return a.target;
    } else {
        return [a pop];
    }
}


- (TDTokenizer *)tokenizer {
    return tokenizer;
}


- (void)setTokenizer:(TDTokenizer *)t {
    if (tokenizer != t) {
        [tokenizer autorelease];
        tokenizer = [t retain];
    }
}

@end
