//
//  TDNCNameState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNCNameState.h"
#import "TDTokenizer.h"
#import "TDReader.h"
#import "TDXmlToken.h"

@interface TDTokenizerState ()
- (void)resetWithReader:(TDReader *)r;
- (void)append:(TDUniChar)c;
- (NSString *)bufferedString;
@end

@interface TDNCNameState ()
+ (BOOL)isNameChar:(TDUniChar)c;
+ (BOOL)isValidStartSymbolChar:(TDUniChar)c;
+ (BOOL)isValidNonStartSymbolChar:(TDUniChar)c;
@end

// NCName       ::=       (Letter | '_') (NameChar)*
@implementation TDNCNameState

//- (BOOL)isWhitespace:(TDUniChar)c {
//    return (' ' == c || '\n' == c || '\r' == c || '\t' == c);
//}


//    NameChar       ::=        Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender
+ (BOOL)isNameChar:(TDUniChar)c {
    if (isalnum(c)) {
        return YES;
    } else if ([self isValidNonStartSymbolChar:c]) {
        return YES;
    }
    // TODO CombiningChar & Extender
    return NO;
}


+ (BOOL)isValidStartSymbolChar:(TDUniChar)c {
    return ('_' == c);
}


+ (BOOL)isValidNonStartSymbolChar:(TDUniChar)c {
    return ('_' == c || '.' == c || '-' == c);
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(TDUniChar)cin tokenizer:(TDTokenizer *)t {
    [self resetWithReader:r];
    
    NSInteger c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([TDNCNameState isNameChar:c]);
    
    if (TDEOF != c) {
        [r unread];
    }
    
    if ([[self bufferedString] length] == 1 && [TDNCNameState isValidStartSymbolChar:cin]) {
        return [t.symbolState nextTokenFromReader:r startingWith:cin tokenizer:t];
    } else {
//        return [[[TDXmlToken alloc] initWithTokenType:TDTT_NAME 
//                                           stringValue:[[stringbuf copy] autorelease] 
//                                            floatValue:0.0] autorelease];
        return nil;
    }
}

@end
