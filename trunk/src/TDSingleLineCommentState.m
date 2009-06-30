//
//  TDSingleLineCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDSingleLineCommentState.h>
#import <ParseKit/TDCommentState.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/TDTokenizer.h>
#import <ParseKit/TDToken.h>
#import <ParseKit/PKTypes.h>

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
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


- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
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
