//
//  PKNumberState.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKNumberState.h>
#import <ParseKit/PKReader.h>
#import <ParseKit/PKToken.h>
#import <ParseKit/PKTokenizer.h>
#import <ParseKit/PKSymbolState.h>
#import <ParseKit/PKTypes.h>

@interface PKToken ()
@property (nonatomic, readwrite) NSUInteger offset;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (NSString *)bufferedString;
@end

@interface PKNumberState ()
- (CGFloat)absorbDigitsFromReader:(PKReader *)r;
- (CGFloat)value;
- (void)parseLeftSideFromReader:(PKReader *)r;
- (void)parseRightSideFromReader:(PKReader *)r;
- (void)parseExponentFromReader:(PKReader *)r;
- (void)reset:(PKUniChar)cin;
- (void)checkForHex:(PKReader *)r;
- (void)checkForOctal;
@end

@implementation PKNumberState

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    [self resetWithReader:r];
    isNegative = NO;
    originalCin = cin;
    
    if ('-' == cin) {
        isNegative = YES;
        cin = [r read];
        [self append:'-'];
    } else if ('+' == cin) {
        cin = [r read];
        [self append:'+'];
    }
    
    [self reset:cin];
    if ('.' == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        if (isDecimal) {
            [self parseRightSideFromReader:r];
        }
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (isNegative && PKEOF != c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (PKEOF != c) {
        [r unread];
    }

    if (isNegative) {
        floatValue = -floatValue;
    }
    
    PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeNumber stringValue:[self bufferedString] floatValue:[self value]];
    tok.offset = offset;
    return tok;
}


- (CGFloat)value {
    CGFloat result = (CGFloat)floatValue;
    
    NSUInteger i = 0;
    for ( ; i < exp; i++) {
        if (negativeExp) {
            result /= (CGFloat)10.0;
        } else {
            result *= (CGFloat)10.0;
        }
    }
    
    return (CGFloat)result;
}


- (CGFloat)absorbDigitsFromReader:(PKReader *)r {
    CGFloat divideBy = 1.0;
    CGFloat v = 0.0;
    
    while (1) {
        if (allowsHexidecimalNotation) {
            [self checkForHex:r];
        }
        if (isdigit(c)) {
            [self append:c];
            len++;
            gotADigit = YES;

            if (allowsOctalNotation) {
                [self checkForOctal];
            }
            
            v = v * base + (c - '0');
            c = [r read];
            if (isFraction) {
                divideBy *= base;
            }
        } else {
            break;
        }
    }
    
    if (isFraction) {
        v = v / divideBy;
    }

    return (CGFloat)v;
}


- (void)parseLeftSideFromReader:(PKReader *)r {
    isFraction = NO;
    floatValue = [self absorbDigitsFromReader:r];
}


- (void)parseRightSideFromReader:(PKReader *)r {
    if ('.' == c) {
        PKUniChar n = [r read];
        BOOL nextIsDigit = isdigit(n);
        if (PKEOF != n) {
            [r unread];
        }

        if (nextIsDigit || allowsTrailingDot) {
            [self append:'.'];
            if (nextIsDigit) {
                c = [r read];
                isFraction = YES;
                floatValue += [self absorbDigitsFromReader:r];
            }
        }
    }
    
    if (allowsScientificNotation) {
        [self parseExponentFromReader:r];
    }
}


- (void)parseExponentFromReader:(PKReader *)r {
    NSParameterAssert(r);    
    if ('e' == c || 'E' == c) {
        PKUniChar e = c;
        c = [r read];
        
        BOOL hasExp = isdigit(c);
        negativeExp = ('-' == c);
        BOOL positiveExp = ('+' == c);
        
        if (!hasExp && (negativeExp || positiveExp)) {
            c = [r read];
            hasExp = isdigit(c);
        }
        if (PKEOF != c) {
            [r unread];
        }
        if (hasExp) {
            [self append:e];
            if (negativeExp) {
                [self append:'-'];
            } else if (positiveExp) {
                [self append:'+'];
            }
            c = [r read];
            isFraction = NO;
            exp = [self absorbDigitsFromReader:r];
        }
    }
}


- (void)reset:(PKUniChar)cin {
    c = cin;
    firstNum = cin;
    gotADigit = NO;
    isFraction = NO;
    isDecimal = YES;   
    len = 0;
    base = (CGFloat)10.0;
    floatValue = (CGFloat)0.0;
    exp = (CGFloat)0.0;
    negativeExp = NO;
}


- (void)checkForHex:(PKReader *)r {
    if ('x' == c && '0' == firstNum && !isFraction && 1 == len) {
        [self append:c];
        len++;
        c = [r read];
        isDecimal = NO;
        base = (CGFloat)16.0;
    }
}


- (void)checkForOctal {
    if ('0' == firstNum && !isFraction && isDecimal && 2 == len) {
        isDecimal = NO;
        base = (CGFloat)8.0;
    }
}

@synthesize allowsTrailingDot;
@synthesize allowsScientificNotation;
@synthesize allowsOctalNotation;
@synthesize allowsHexidecimalNotation;
@end
