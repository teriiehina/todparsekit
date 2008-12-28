//
//  TDCommentState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCommentState.h"
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDSingleLineCommentState.h>
#import <TDParseKit/TDMultiLineCommentState.h>

@interface TDCommentState ()
@property (nonatomic, retain) TDSingleLineCommentState *singleLineState;
@property (nonatomic, retain) TDMultiLineCommentState *multiLineState;
@end

@implementation TDCommentState

- (id)init {
    self = [super init];
    if (self) {
        self.singleLineState = [[[TDSingleLineCommentState alloc] init] autorelease];
        self.multiLineState = [[[TDSingleLineCommentState alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.singleLineState = nil;
    self.multiLineState = nil;
    [super dealloc];
}


- (void)addSingleLineStartToken:(TDToken *)startTok {
    
}


- (void)addMultiLineStartToken:(TDToken *)startTok endToken:(TDToken *)endTok {
    
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);
    
    NSInteger c = [r read];
    if ('/' == c) {
        return [singleLineState nextTokenFromReader:r startingWith:c tokenizer:t];
    } else if ('*' == c) {
        return [multiLineState nextTokenFromReader:r startingWith:c tokenizer:t];
    } else {
        if (-1 != c) {
            [r unread];
        }
        return [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:[NSString stringWithFormat:@"%C", cin] floatValue:0.0];
    }
}

@synthesize singleLineState;
@synthesize multiLineState;
@synthesize reportsCommentTokens;
@synthesize balancesEOFTerminatedComments;
@end
