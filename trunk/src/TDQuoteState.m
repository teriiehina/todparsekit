//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDQuoteState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTypes.h>

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(TDUniChar)c;
- (NSString *)bufferedString;
@end

@implementation TDQuoteState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    
    [self append:cin];
    TDUniChar c;
    do {
        c = [r read];
        if (TDEOF == c) {
            c = cin;
            if (balancesEOFTerminatedStrings) {
                [self append:c];
            }
        } else {
            [self append:c];
        }
        
    } while (c != cin);
    
    return [TDToken tokenWithTokenType:TDTokenTypeQuotedString stringValue:[self bufferedString] floatValue:0.0];
}

@synthesize balancesEOFTerminatedStrings;
@end
