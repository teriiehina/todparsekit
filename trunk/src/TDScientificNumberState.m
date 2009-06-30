//
//  TDScientificNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDScientificNumberState.h"
#import <ParseKit/PKReader.h>
#import <ParseKit/PKTypes.h>

@interface PKTokenizerState ()
- (void)append:(PKUniChar)c;
@end

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(PKReader *)r isFraction:(BOOL)isFraction;
- (void)parseRightSideFromReader:(PKReader *)r;
- (void)reset:(PKUniChar)cin;
- (CGFloat)value;
@end

@implementation TDScientificNumberState

- (void)parseRightSideFromReader:(PKReader *)r {
    NSParameterAssert(r);
    [super parseRightSideFromReader:r];
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
            exp = [super absorbDigitsFromReader:r isFraction:NO];
        }
    }
}


- (void)reset:(PKUniChar)cin {
    [super reset:cin];
    exp = (CGFloat)0.0;
    negativeExp = NO;
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

@end
