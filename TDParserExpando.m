//
//  TDParserExpando.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDParserExpando.h"
#import "TDGrammarParserFactory.h"

@interface TDGrammarParserFactory ()
- (TDSequence *)parserForExpression:(NSString *)s;
@end

@interface TDParserExpando ()
- (TDCollectionParser *)expandedParserForName:(NSString *)n;

@property (nonatomic, retain) NSMutableDictionary *table;
@property (nonatomic, retain) TDGrammarParserFactory *factory;
@end

@implementation TDParserExpando

- (id)init {
    self = [super init];
    if (self) {
        self.table = [NSMutableDictionary dictionary];
        self.factory = [TDGrammarParserFactory factory];
    }
    return self;
}


- (void)dealloc {
    self.table = nil;
    self.factory = nil;
    [super dealloc];
}


- (TDParser *)parserForName:(NSString *)n {
    NSParameterAssert(n);
    id obj = [table objectForKey:n];
    if ([obj isKindOfClass:[TDParser class]]) {
        return obj;
    } else {
        TDParser *p = [self expandedParserForName:n];
        [table setObject:p forKey:n];
        return p;
    }
}


- (void)setExpression:(NSString *)expr forParserName:(NSString *)n {
    NSParameterAssert(expr);
    NSParameterAssert(n);
    [table setObject:expr forKey:n];
}


#pragma mark -
#pragma mark Private

- (TDCollectionParser *)expandedParserForName:(NSString *)n {
    NSParameterAssert(n);
    NSString *expr = [table objectForKey:n];
    NSAssert([expr isKindOfClass:[NSString class]], @"");
    return [factory parserForExpression:expr];
}

@synthesize table;
@synthesize factory;
@end
