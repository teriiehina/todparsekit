//
//  TDBlobState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDBlobState.h"
#import <ParseKit/TDToken.h>
#import <ParseKit/PKReader.h>
#import "TDToken+Blob.h"

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(TDUniChar)c;
- (NSString *)bufferedString;
@end

@implementation TDBlobState

- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];
    
    TDUniChar c = cin;
    do {
        [self append:c];
        c = [r read];
    } while (TDEOF != c && !isspace(c));
    
    if (TDEOF != c) {
        [r unread];
    }
    
    TDToken *tok = [TDToken tokenWithTokenType:TDTokenTypeBlob stringValue:[self bufferedString] floatValue:0.0];
    tok.offset = offset;
    return tok;
}

@end
