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

@interface TDTokenizer ()
- (TDTokenizerState *)defaultTokenizerStateFor:(TDUniChar)c;
@end

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(TDUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDDelimitState ()
- (void)unreadString:(NSString *)s fromReader:(TDReader *)r;
- (NSString *)endMarkerForStartMarker:(NSString *)startMarker;
- (NSCharacterSet *)allowedCharacterSetForStartMarker:(NSString *)startMarker;
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) NSMutableArray *startMarkers;
@property (nonatomic, retain) NSMutableArray *endMarkers;
@property (nonatomic, retain) NSMutableArray *characterSets;
@end

@implementation TDDelimitState

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.startMarkers = [NSMutableArray array];
        self.endMarkers = [NSMutableArray array];
        self.characterSets = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.startMarkers = nil;
    self.endMarkers = nil;
    self.characterSets = nil;
    [super dealloc];
}


- (void)addStartMarker:(NSString *)start endMarker:(NSString *)end allowedCharacterSet:(NSCharacterSet *)set{
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [rootNode add:start];
    [rootNode add:end];
    [startMarkers addObject:start];
    [endMarkers addObject:end];
    [characterSets addObject:set ? set : (id)[NSNull null]];
}


- (void)removeStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    NSUInteger i = [startMarkers indexOfObject:start];
    if (NSNotFound != i) {
        [startMarkers removeObject:start];
        [characterSets removeObjectAtIndex:i];
        
        NSString *end = [endMarkers objectAtIndex:i];
        [rootNode remove:end];
        [endMarkers removeObjectAtIndex:i]; // this should always be in range.
    }
}


- (void)unreadString:(NSString *)s fromReader:(TDReader *)r {
    NSUInteger len = s.length;
    NSUInteger i = 0;
    for ( ; i < len - 1; i++) {
        [r unread];
    }
}


- (NSString *)endMarkerForStartMarker:(NSString *)startMarker {
    NSParameterAssert([startMarkers containsObject:startMarker]);
    NSUInteger i = [startMarkers indexOfObject:startMarker];
    return [endMarkers objectAtIndex:i];
}


- (NSCharacterSet *)allowedCharacterSetForStartMarker:(NSString *)startMarker {
    NSParameterAssert([startMarkers containsObject:startMarker]);
    NSCharacterSet *characterSet = nil;
    NSUInteger i = [startMarkers indexOfObject:startMarker];
    id csOrNull = [characterSets objectAtIndex:i];
    if ([NSNull null] != csOrNull) {
        characterSet = csOrNull;
    }
    return characterSet;
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    NSString *startMarker = [rootNode nextSymbol:r startingWith:cin];

    // if cin does not actually signal the start of a delimiter symbol string, unwind and return a symbol tok
    if (!startMarker.length || ![startMarkers containsObject:startMarker]) {
        [self unreadString:startMarker fromReader:r];
        return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
    
    [self reset];
    [self appendString:startMarker];

    NSString *endMarker = [self endMarkerForStartMarker:startMarker];
    NSCharacterSet *characterSet = [self allowedCharacterSetForStartMarker:startMarker];
    
    TDUniChar c;
    TDUniChar e = [endMarker characterAtIndex:0];
    while (1) {
        c = [r read];
        if (TDEOF == c) {
            if (balancesEOFTerminatedStrings) {
                [self appendString:endMarker];
            }
            break;
        }
        
        if (e == c) {
            NSString *peek = [rootNode nextSymbol:r startingWith:e];
            if ([endMarker isEqualToString:peek]) {
                [self appendString:endMarker];
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
            return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
        }
    }
    
    if (TDEOF != c) {
        [r unread];
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeDelimitedString stringValue:[self bufferedString] floatValue:0.0];
}

@synthesize rootNode;
@synthesize balancesEOFTerminatedStrings;
@synthesize startMarkers;
@synthesize endMarkers;
@synthesize characterSets;
@end
