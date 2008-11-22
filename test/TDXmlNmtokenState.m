//
//  TDXmlNmtokenState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlNmtokenState.h"
#import "TDTokenizer.h"
#import "TDReader.h"
#import "TDXmlToken.h"

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@interface TDXmlNameState ()
+ (BOOL)isNameChar:(NSInteger)c;
+ (BOOL)isValidStartSymbolChar:(NSInteger)c;
@end

// NameChar       ::=        Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar | Extender
@implementation TDXmlNmtokenState

+ (BOOL)isValidStartSymbolChar:(NSInteger)c {
    return ('_' == c || ':' == c || '-' == c || '.' == c);
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    [self reset];
    
    NSInteger c = cin;
    do {
        [stringbuf appendFormat:@"%C", c];
        c = [r read];
    } while ([[self class] isNameChar:c]);
    
    if (c != -1) {
        [r unread];
    }
    
    if (self.stringbuf.length == 1 && [[self class] isValidStartSymbolChar:cin]) {
        return [t.symbolState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else if (self.stringbuf.length == 1 && isdigit(cin)) {
        return [t.numberState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
        return nil;
//        return [[[TDXmlToken alloc] initWithTokenType:TDTT_NMTOKEN
//                                           stringValue:[[stringbuf copy] autorelease] 
//                                            floatValue:0.0f] autorelease];
    }
}

@end
