//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDSingleLineCommentState.h>
#import <TDParseKit/TDCommentState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTypes.h>

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(TDReader *)r;
- (void)append:(TDUniChar)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;
@end

@interface TDSingleLineCommentState ()
- (void)addStartMarker:(NSString *)start;
- (void)removeStartMarker:(NSString *)start;
@property (nonatomic, retain) NSMutableArray *startMarkers;
@property (nonatomic, retain) NSString *currentStartMarker;
@end

@implementation TDSingleLineCommentState

- (id)init {
    if (self = [super init]) {
        self.startMarkers = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startMarkers = nil;
    self.currentStartMarker = nil;
    [super dealloc];
}


- (void)addStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [startMarkers addObject:start];
}


- (void)removeStartMarker:(NSString *)start {
    NSParameterAssert(start.length);
    [startMarkers removeObject:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self resetWithReader:r];
        [self appendString:currentStartMarker];
    }
    
    TDUniChar c;
    while (1) {
        c = [r read];
        if ('\n' == c || '\r' == c || TDEOF == c) {
            break;
        }
        if (reportTokens) {
            [self append:c];
        }
    }
    
    if (TDEOF != c) {
        [r unread];
    }
    
    self.currentStartMarker = nil;
    
    if (reportTokens) {
        TDToken *tok = [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
        tok.offset = offset;
        return tok;
    } else {
        return [t nextToken];
    }
}

@synthesize startMarkers;
@synthesize currentStartMarker;
@end
