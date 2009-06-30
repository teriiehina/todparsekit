//
//  PKParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKParser.h>
#import <ParseKit/PKAssembly.h>
#import <ParseKit/TDTokenAssembly.h>
#import <ParseKit/TDTokenizer.h>

@interface PKParser ()
- (NSSet *)matchAndAssemble:(NSSet *)inAssemblies;
- (PKAssembly *)best:(NSSet *)inAssemblies;
@end

@interface PKParser (PKParserFactoryAdditionsFriend)
- (void)setTokenizer:(TDTokenizer *)t;
@end

@implementation PKParser

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


- (PKParser *)parserNamed:(NSString *)s {
    if ([name isEqualToString:s]) {
        return self;
    }
    return nil;
}


- (NSSet *)allMatchesFor:(NSSet *)inAssemblies {
    NSAssert1(0, @"-[PKParser %s] must be overriden", _cmd);
    return nil;
}


- (PKAssembly *)bestMatchFor:(PKAssembly *)a {
    NSParameterAssert(a);
    NSSet *initialState = [NSSet setWithObject:a];
    NSSet *finalState = [self matchAndAssemble:initialState];
    return [self best:finalState];
}


- (PKAssembly *)completeMatchFor:(PKAssembly *)a {
    NSParameterAssert(a);
    PKAssembly *best = [self bestMatchFor:a];
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
        for (PKAssembly *a in outAssemblies) {
            [assembler performSelector:selector withObject:a];
        }
    }
    return outAssemblies;
}


- (PKAssembly *)best:(NSSet *)inAssemblies {
    NSParameterAssert(inAssemblies);
    PKAssembly *best = nil;
    
    for (PKAssembly *a in inAssemblies) {
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

@implementation PKParser (PKParserFactoryAdditions)

- (id)parse:(NSString *)s {
    TDTokenizer *t = self.tokenizer;
    if (!t) {
        t = [TDTokenizer tokenizer];
    }
    t.string = s;
    PKAssembly *a = [self completeMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
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
