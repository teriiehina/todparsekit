//
//  TDNumberState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDNumberState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDSymbolState.h>

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@interface TDNumberState ()
- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)fraction;
- (CGFloat)value;
- (void)parseLeftSideFromReader:(TDReader *)r;
- (void)parseRightSideFromReader:(TDReader *)r;
- (void)reset:(NSInteger)cin;
@end

@implementation TDNumberState

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSParameterAssert(r);
    [self reset];
    negative = NO;
    char originalCin = cin;
    
    if ('-' == cin) {
        negative = YES;
        cin = [r read];
        [stringbuf appendString:@"-"];
    } else if ('+' == cin) {
        cin = [r read];
        [stringbuf appendString:@"+"];
    }
    
    [self reset:cin];
    if ('.' == c) {
        [self parseRightSideFromReader:r];
    } else {
        [self parseLeftSideFromReader:r];
        [self parseRightSideFromReader:r];
    }
    
    // erroneous ., +, or -
    if (!gotADigit) {
        if (negative && '-' == c) { // ??
            [r unread];
        }
        return [t.symbolState nextTokenFromReader:r startingWith:originalCin tokenizer:t];
    }
    
    if (-1 != c) {
        [r unread];
    }

    if (negative) {
        floatValue = -floatValue;
    }
    
    return [TDToken tokenWithTokenType:TDTokenTypeNumber stringValue:[[stringbuf copy] autorelease] floatValue:[self value]];
}


- (CGFloat)value {
    return floatValue;
}


- (CGFloat)absorbDigitsFromReader:(TDReader *)r isFraction:(BOOL)isFraction {
    CGFloat divideBy = 1.0f;
    CGFloat v = 0.0f;
    
    while (1) {
        if (isdigit(c)) {
            [stringbuf appendFormat:@"%C", c];
            gotADigit = YES;
            v = v * 10.0f + (c - '0');
            c = [r read];
            if (isFraction) {
                divideBy *= 10.0f;
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


- (void)parseLeftSideFromReader:(TDReader *)r {
    floatValue = [self absorbDigitsFromReader:r isFraction:NO];
}


- (void)parseRightSideFromReader:(TDReader *)r {
    if ('.' == c) {
        NSInteger n = [r read];
        BOOL nextIsDigit = isdigit(n);
        if (-1 != n) {
            [r unread];
        }

        if (nextIsDigit || allowsTrailingDot) {
            [stringbuf appendString:@"."];
            if (nextIsDigit) {
                c = [r read];
                floatValue += [self absorbDigitsFromReader:r isFraction:YES];
            }
        }
    }
}


- (void)reset:(NSInteger)cin {
    gotADigit = NO;
    floatValue = 0.0f;
    c = cin;
}

@synthesize allowsTrailingDot;
@end