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

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (NSString *)bufferedString;
@end

@interface TDSingleLineCommentState ()
@end

@implementation TDSingleLineCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.startSymbols = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.startSymbols = nil;
    [super dealloc];
}


- (void)addStartSymbol:(NSString *)start {
    NSParameterAssert(start.length);
    [startSymbols addObject:start];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    BOOL reportTokens = t.commentState.reportsCommentTokens;
    if (reportTokens) {
        [self reset];
    }
    
    NSInteger c = cin;
    
    while ('\n' != c && '\r' != c && -1 != c) {
        if (reportTokens) {
            [self append:c];
        }
        c = [r read];
    }
    if (-1 != c) {
        [r unread];
    }
    
    if (reportTokens) {
        return [TDToken tokenWithTokenType:TDTokenTypeComment stringValue:[self bufferedString] floatValue:0.0];
    } else {
        return [t nextToken];
    }
}

@synthesize startSymbols;
@end
