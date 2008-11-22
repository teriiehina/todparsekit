//
//  TDScientificNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/25/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDScientificNumberState.h"
#import <TDParseKit/TDReader.h>

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
- (CGFloat)value;
@end

@implementation TDScientificNumberState

- (void)parseRightSideFromReader:(TDReader *)r {
    [super parseRightSideFromReader:r];
    if ('e' == c || 'E' == c) {
        NSInteger e = c;
        c = [r read];
        
        BOOL hasExp = isdigit(c);
        negativeExp = ('-' == c);
        BOOL positiveExp = ('+' == c);

        if (!hasExp && (negativeExp || positiveExp)) {
            c = [r read];
            hasExp = isdigit(c);
        }
        if (-1 != c) {
            [r unread];
        }
        if (hasExp) {
            [stringbuf appendFormat:@"%C", e];
            if (negativeExp) {
                [stringbuf appendString:@"-"];
            } else if (positiveExp) {
                [stringbuf appendString:@"+"];
            }
            c = [r read];
            exp = [super absorbDigitsFromReader:r isFraction:NO];
        }
    }
}


- (void)reset:(NSInteger)cin {
    [super reset:cin];
    exp = 0.0f;
    negativeExp = NO;
}


- (CGFloat)value {
    CGFloat result = floatValue;
    
    NSInteger i = 0;
    for ( ; i < exp; i++) {
        result *= 10.0f;
    }
    
    if (negativeExp) {
        result = -result;
    }
    
    return (CGFloat)result;
}

@end
