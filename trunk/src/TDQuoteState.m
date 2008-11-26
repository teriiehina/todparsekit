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

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@implementation TDQuoteState

- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    [self reset];
    
    [stringbuf appendFormat:@"%C", cin];
    NSInteger c;
    do {
        c = [r read];
        if (c < 0) {
            c = cin;
        }
        
        [stringbuf appendFormat:@"%C", c];
    } while (c != cin);
    
    return [TDToken tokenWithTokenType:TDTokenTypeQuoted stringValue:stringbuf floatValue:0.0f];
}

@end
