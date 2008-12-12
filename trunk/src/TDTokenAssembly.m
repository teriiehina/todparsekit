//
//  TDTokenAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenAssembly.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>

@interface TDTokenAssembly ()
- (void)tokenize;
- (NSString *)objectsFrom:(NSInteger)start to:(NSInteger)end separatedBy:(NSString *)delimiter;
@property (nonatomic, retain) NSMutableArray *tokens;
@end

@implementation TDTokenAssembly

+ (id)assemblyWithTokenizer:(TDTokenizer *)t {
    return [[[self alloc] initWithTokenzier:t] autorelease];
}


- (id)initWithTokenzier:(TDTokenizer *)t {
    NSParameterAssert(t);
    self = [super initWithString:t.string];
    if (self) {
        self.tokenizer = t;
    }
    return self;
}


- (id)initWithString:(NSString *)s {
    return [self initWithTokenzier:[[[TDTokenizer alloc] initWithString:s] autorelease]];
}


- (void)dealloc {
    self.tokenizer = nil;
    self.tokens = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    TDTokenAssembly *a = (TDTokenAssembly *)[super copyWithZone:zone];
    a->tokens = [self.tokens mutableCopy];
    return a;
}


- (NSMutableArray *)tokens {
    if (!tokens) {
        [self tokenize];
    }
    return [[tokens retain] autorelease];
}


- (void)setTokens:(NSMutableArray *)inArray {
    if (inArray != tokens) {
        [tokens autorelease];
        tokens = [inArray retain];
    }
}


- (id)peek {
    if (index >= self.tokens.count) {
        return nil;
    }
    id tok = [self.tokens objectAtIndex:index];
    
    return tok;
}


- (id)next {
    id tok = [self peek];
    if (tok) {
        index++;
    }
    return tok;
}


- (BOOL)hasMore {
    return (index < self.tokens.count);
}


- (NSInteger)length {
    return self.tokens.count;
} 


- (NSInteger)objectsConsumed {
    return index;
}


- (NSInteger)objectsRemaining {
    return (self.tokens.count - index);
}


- (NSString *)consumedObjectsSeparatedBy:(NSString *)delimiter {
    return [self objectsFrom:0 to:self.objectsConsumed separatedBy:delimiter];
}


- (NSString *)remainingObjectsSeparatedBy:(NSString *)delimiter {
    return [self objectsFrom:self.objectsConsumed to:self.length separatedBy:delimiter];
}


#pragma mark -
#pragma mark Private

- (void)tokenize {
    self.tokens = [NSMutableArray array];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    while ((tok = [tokenizer nextToken]) != eof) {
        [tokens addObject:tok];
    }
}


- (NSString *)objectsFrom:(NSInteger)start to:(NSInteger)end separatedBy:(NSString *)delimiter {
    NSMutableString *s = [NSMutableString string];

    NSInteger i = start;
    for ( ; i < end; i++) {
        TDToken *tok = [self.tokens objectAtIndex:i];
        [s appendString:tok.stringValue];
        if (end - 1 != i) {
            [s appendString:delimiter];
        }
    }
    
    return [[s copy] autorelease];
}

@synthesize tokenizer;
@end
