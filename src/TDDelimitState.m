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
#import <TDParseKit/TDWhitespaceState.h>
#import <TDParseKit/TDSymbolRootNode.h>
#import <TDParseKit/TDTypes.h>

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizer ()
- (TDTokenizerState *)defaultTokenizerStateFor:(TDUniChar)c;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(TDReader *)r;
- (void)append:(TDUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDDelimitState ()
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


- (void)addStartMarker:(NSString *)start endMarker:(NSString *)end allowedCharacterSet:(NSCharacterSet *)set {
    NSParameterAssert(start.length);
    [rootNode add:start];
    [startMarkers addObject:start];
    
    if (end) {
        [rootNode add:end];
        [endMarkers addObject:end];
    } else {
        [endMarkers addObject:[NSNull null]];
    }

    if (set) {
        [characterSets addObject:set];
    } else {
        [characterSets addObject:[NSNull null]];
    }
}


- (void)removeStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    NSUInteger i = [startMarkers indexOfObject:start];
    if (NSNotFound != i) {
        [startMarkers removeObject:start];
        [characterSets removeObjectAtIndex:i];
        
        id endOrNull = [endMarkers objectAtIndex:i];
        if ([NSNull null] != endOrNull) {
            [rootNode remove:endOrNull];
        }
        [endMarkers removeObjectAtIndex:i]; // this should always be in range.
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

    if (!startMarker.length || ![startMarkers containsObject:startMarker]) {
        [r unread:startMarker.length - 1];
        return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
    
    [self resetWithReader:r];
    [self appendString:startMarker];

    id endMarkerOrNull = [self endMarkerForStartMarker:startMarker];
    NSString *endMarker = nil;
    NSCharacterSet *characterSet = [self allowedCharacterSetForStartMarker:startMarker];
    
    TDUniChar c, e;
    if ([NSNull null] == endMarkerOrNull) {
        e = TDEOF;
    } else {
        endMarker = endMarkerOrNull;
        e = [endMarker characterAtIndex:0];
    }
    while (1) {
        c = [r read];
        if (TDEOF == c) {
            if (balancesEOFTerminatedStrings && endMarker) {
                [self appendString:endMarker];
            }
            break;
        }
        
        if (!endMarker && [t.whitespaceState isWhitespaceChar:c]) {
            // if only the start marker was matched, dont return delimited string token. instead, defer tokenization
            if ([startMarker isEqualToString:[self bufferedString]]) {
                [r unread:startMarker.length - 1];
                return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
            }
            // else, return delimited string tok
            break;
        }
        
        if (e == c) {
            NSString *peek = [rootNode nextSymbol:r startingWith:e];
            if (endMarker && [endMarker isEqualToString:peek]) {
                [self appendString:endMarker];
                c = [r read];
                break;
            } else {
                [r unread:peek.length - 1];
                if (e != [peek characterAtIndex:0]) {
                    [self append:c];
                    c = [r read];
                }
            }
        }


        // check if char is not in allowed character set (if given)
        if (characterSet && ![characterSet characterIsMember:c]) {
            if (allowsUnbalancedStrings) {
                break;
            } else {
                // if not, unwind and return a symbol tok for cin
                [r unread:[[self bufferedString] length]];
                return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
            }
        }
        
        [self append:c];
    }
    
    if (TDEOF != c) {
        [r unread];
    }
    
    TDToken *tok = [TDToken tokenWithTokenType:TDTokenTypeDelimitedString stringValue:[self bufferedString] floatValue:0.0];
    tok.offset = offset;
    return tok;
}

@synthesize rootNode;
@synthesize balancesEOFTerminatedStrings;
@synthesize allowsUnbalancedStrings;
@synthesize startMarkers;
@synthesize endMarkers;
@synthesize characterSets;
@end
