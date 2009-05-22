//
//  TDDelimitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDDelimitState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDSymbolRootNode.h>
#import <TDParseKit/TDTypes.h>

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(TDUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDDelimitState ()
- (NSString *)endSymbolForStartSymbol:(NSString *)startSymbol;
- (NSCharacterSet *)allowedCharacterSetForStartSymbol:(NSString *)startSymbol;
- (TDToken *)symbolTokenFor:(TDUniChar)cin;
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) NSMutableArray *startSymbols;
@property (nonatomic, retain) NSMutableArray *endSymbols;
@property (nonatomic, retain) NSMutableArray *characterSets;
@end

@implementation TDDelimitState

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.startSymbols = [NSMutableArray array];
        self.endSymbols = [NSMutableArray array];
        self.characterSets = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.startSymbols = nil;
    self.endSymbols = nil;
    self.characterSets = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start endSymbol:(NSString *)end allowedCharacterSet:(NSCharacterSet *)cs {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [rootNode add:start];
    [rootNode add:end];
    [startSymbols addObject:start];
    [endSymbols addObject:end];
    [characterSets addObject:cs ? cs : (id)[NSNull null]];
}


- (void)removeStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    NSUInteger i = [startSymbols indexOfObject:start];
    if (NSNotFound != i) {
        [startSymbols removeObject:start];
        [endSymbols removeObjectAtIndex:i]; // this should always be in range.
    }
}


- (void)unreadString:(NSString *)s fromReader:(TDReader *)r {
    NSUInteger len = s.length;
    NSUInteger i = 0;
    for ( ; i < len - 1; i++) {
        [r unread];
    }
}


- (NSString *)endSymbolForStartSymbol:(NSString *)startSymbol {
    NSParameterAssert([startSymbols containsObject:startSymbol]);
    NSUInteger i = [startSymbols indexOfObject:startSymbol];
    return [endSymbols objectAtIndex:i];
}


- (NSCharacterSet *)allowedCharacterSetForStartSymbol:(NSString *)startSymbol {
    NSParameterAssert([startSymbols containsObject:startSymbol]);
    NSCharacterSet *characterSet = nil;
    NSUInteger i = [startSymbols indexOfObject:startSymbol];
    id csOrNull = [characterSets objectAtIndex:i];
    if ([NSNull null] != csOrNull) {
        characterSet = csOrNull;
    }
    return characterSet;
}


- (TDToken *)symbolTokenFor:(TDUniChar)cin {
    return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", cin] floatValue:0.0];    
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    NSString *startSymbol = [rootNode nextSymbol:r startingWith:cin];

    // if cin does not actually signal the start of a delimiter symbol string, unwind and return a symbol tok
    if (!startSymbol.length || ![startSymbols containsObject:startSymbol]) {
        [self unreadString:startSymbol fromReader:r];
        return [self symbolTokenFor:cin];
    }
    
    [self reset];
    [self appendString:startSymbol];

    NSString *endSymbol = [self endSymbolForStartSymbol:startSymbol];
    NSCharacterSet *characterSet = [self allowedCharacterSetForStartSymbol:startSymbol];
    
    TDUniChar c;
    TDUniChar e = [endSymbol characterAtIndex:0];
    while (1) {
        c = [r read];
        if (TDEOF == c) {
            if (balancesEOFTerminatedStrings) {
                [self appendString:endSymbol];
            }
            break;
        }
        
        if (e == c) {
            NSString *peek = [rootNode nextSymbol:r startingWith:e];
            if ([endSymbol isEqualToString:peek]) {
                [self appendString:endSymbol];
                c = [r read];
                break;
            } else {
                [self unreadString:peek fromReader:r];
                if (e != [peek characterAtIndex:0]) {
                    [self append:c];
                    c = [r read];
                }
            }
        }

        [self append:c];

        // check if char is in allowed character set (if given)
        if (characterSet && ![characterSet characterIsMember:c]) {
            // if not, unwind and return a symbol tok for cin
            [self unreadString:[self bufferedString] fromReader:r];
            return [self symbolTokenFor:cin];
        }
    }
    
    if (TDEOF != c) {
        [r unread];
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeDelimitedString stringValue:[self bufferedString] floatValue:0.0];
}

@synthesize rootNode;
@synthesize balancesEOFTerminatedStrings;
@synthesize startSymbols;
@synthesize endSymbols;
@synthesize characterSets;
@end
