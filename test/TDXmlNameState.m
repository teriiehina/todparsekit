//
//  TDXmlNameState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlNameState.h"
#import "TDTokenizer.h"
#import "TDReader.h"
#import "TDXmlToken.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(TDUniChar)c;
- (NSString *)bufferedString;
@end

@interface TDXmlNameState ()
+ (BOOL)isNameChar:(TDUniChar)c;
+ (BOOL)isValidStartSymbolChar:(TDUniChar)c;
+ (BOOL)isValidNonStartSymbolChar:(TDUniChar)c;
@end

//Name       ::=       (Letter | '_' | ':') (NameChar)*
@implementation TDXmlNameState

//- (BOOL)isWhitespace:(TDUniChar)c {
//    return (' ' == c || '\n' == c || '\r' == c || '\t' == c);
//}


//    NameChar       ::=        Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar | Extender
+ (BOOL)isNameChar:(TDUniChar)c {
    if (isalpha(c)) {
        return YES;
    } else if (isdigit(c)) {
        return YES;
    } else if ([[self class] isValidNonStartSymbolChar:c]) {
        return YES;
    }
    // TODO CombiningChar & Extender
    return NO;
}


+ (BOOL)isValidStartSymbolChar:(TDUniChar)c {
    return ('_' == c || ':' == c);
}


+ (BOOL)isValidNonStartSymbolChar:(TDUniChar)c {
    return ('_' == c || '.' == c || '-' == c || ':' == c);
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    [self reset];
    
    NSInteger c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([[self class] isNameChar:c]);
    
    if (TDEOF != c) {
        [r unread];
    }

    if ([[self bufferedString] length] == 1 && [[self class] isValidStartSymbolChar:cin]) {
        return [t.symbolState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
//        return [[[TDXmlToken alloc] initWithTokenType:TDTT_NAME 
//                                           stringValue:[[stringbuf copy] autorelease] 
//                                            floatValue:0.0] autorelease];
        return nil;
    }
}

@end
