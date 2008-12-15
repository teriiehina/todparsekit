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
- (TDCollectionParser *)expandedParserForName:(NSString *)name;

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


- (TDParser *)parserForName:(NSString *)name {
    NSParameterAssert(name);
    id obj = [table objectForKey:name];
    if ([obj isKindOfClass:[TDParser class]]) {
        return obj;
    } else {
        TDParser *p = [self expandedParserForName:name];
        [table setObject:p forKey:name];
        return p;
    }
}


- (void)setExpression:(NSString *)expr forParserName:(NSString *)name {
    NSParameterAssert(expr);
    NSParameterAssert(name);
    [table setObject:expr forKey:name];
}


#pragma mark -
#pragma mark Private

- (TDCollectionParser *)expandedParserForName:(NSString *)name {
    NSParameterAssert(name);
    NSString *expr = [table objectForKey:name];
    NSAssert([expr isKindOfClass:[NSString class]], @"");
    return [factory parserForExpression:expr];
}

@synthesize table;
@synthesize factory;
@end
