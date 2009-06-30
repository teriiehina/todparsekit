//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDQuoteState.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/TDToken.h>
#import <ParseKit/PKTypes.h>

@interface TDToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface TDTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (NSString *)bufferedString;
@end

@implementation TDQuoteState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];
    
    [self append:cin];
    PKUniChar c;
    do {
        c = [r read];
        if (PKEOF == c) {
            c = cin;
            if (balancesEOFTerminatedQuotes) {
                [self append:c];
            }
        } else {
            [self append:c];
        }
        
    } while (c != cin);
    
    TDToken *tok = [TDToken tokenWithTokenType:TDTokenTypeQuotedString stringValue:[self bufferedString] floatValue:0.0];
    tok.offset = offset;
    return tok;
}

@synthesize balancesEOFTerminatedQuotes;
@end
