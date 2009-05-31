//
//  TDCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDCommentState.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDSymbolRootNode.h>
#import <TDParseKit/TDSingleLineCommentState.h>
#import <TDParseKit/TDMultiLineCommentState.h>

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizer ()
- (TDTokenizerState *)defaultTokenizerStateFor:(TDUniChar)c;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(TDReader *)r;
@end

@interface TDCommentState ()
@property (nonatomic, retain) TDSymbolRootNode *rootNode;
@property (nonatomic, retain) TDSingleLineCommentState *singleLineState;
@property (nonatomic, retain) TDMultiLineCommentState *multiLineState;
@end

@interface TDSingleLineCommentState ()
- (void)addStartMarker:(NSString *)start;
- (void)removeStartMarker:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startMarkers;
@property (nonatomic, retain) NSString *currentStartMarker;
@end

@interface TDMultiLineCommentState ()
- (void)addStartMarker:(NSString *)start endMarker:(NSString *)end;
- (void)removeStartMarker:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startMarkers;
@property (nonatomic, retain) NSMutableArray *endMarkers;
@property (nonatomic, copy) NSString *currentStartMarker;
@end

@implementation TDCommentState

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[[TDSymbolRootNode alloc] init] autorelease];
        self.singleLineState = [[[TDSingleLineCommentState alloc] init] autorelease];
        self.multiLineState = [[[TDMultiLineCommentState alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.rootNode = nil;
    self.singleLineState = nil;
    self.multiLineState = nil;
    [super dealloc];
}


- (void)addSingleLineStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode add:start];
    [singleLineState addStartMarker:start];
}


- (void)removeSingleLineStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [singleLineState removeStartMarker:start];
}


- (void)addMultiLineStartMarker:(NSString *)start endMarker:(NSString *)end {
    NSParameterAssert(start.length);
    NSParameterAssert(end.length);
    [rootNode add:start];
    [rootNode add:end];
    [multiLineState addStartMarker:start endMarker:end];
}


- (void)removeMultiLineStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [rootNode remove:start];
    [multiLineState removeStartMarker:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    [self resetWithReader:r];

    NSString *symbol = [rootNode nextSymbol:r startingWith:cin];

    if ([multiLineState.startMarkers containsObject:symbol]) {
        multiLineState.currentStartMarker = symbol;
        TDToken *tok = [multiLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
        tok.offset = offset;
        return tok;
    } else if ([singleLineState.startMarkers containsObject:symbol]) {
        singleLineState.currentStartMarker = symbol;
        TDToken *tok = [singleLineState nextTokenFromReader:r startingWith:cin tokenizer:t];
        tok.offset = offset;
        return tok;
    } else {
        NSUInteger i = 0;
        for ( ; i < symbol.length - 1; i++) {
            [r unread];
        }
        return [[t defaultTokenizerStateFor:cin] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
}

@synthesize rootNode;
@synthesize singleLineState;
@synthesize multiLineState;
@synthesize reportsCommentTokens;
@synthesize balancesEOFTerminatedComments;
@end
