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
- (void)append:(NSInteger)c;
- (NSString *)bufferedString;
@end

@interface TDXmlNameState ()
+ (BOOL)isNameChar:(NSInteger)c;
+ (BOOL)isValidStartSymbolChar:(NSInteger)c;
+ (BOOL)isValidNonStartSymbolChar:(NSInteger)c;
@end

//Name       ::=       (Letter | '_' | ':') (NameChar)*
@implementation TDXmlNameState

//- (BOOL)isWhitespace:(NSInteger)c {
//    return (' ' == c || '\n' == c || '\r' == c || '\t' == c);
//}


//    NameChar       ::=        Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar | Extender
+ (BOOL)isNameChar:(NSInteger)c {
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


+ (BOOL)isValidStartSymbolChar:(NSInteger)c {
    return ('_' == c || ':' == c);
}


+ (BOOL)isValidNonStartSymbolChar:(NSInteger)c {
    return ('_' == c || '.' == c || '-' == c || ':' == c);
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    [self reset];
    
    NSInteger c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([[self class] isNameChar:c]);
    
    if (c != -1) {
        [r unread];
    }

    if ([self bufferedString] == 1 && [[self class] isValidStartSymbolChar:cin]) {
        return [t.symbolState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
//        return [[[TDXmlToken alloc] initWithTokenType:TDTT_NAME 
//                                           stringValue:[[stringbuf copy] autorelease] 
//                                            floatValue:0.0] autorelease];
        return nil;
    }
}

@end
