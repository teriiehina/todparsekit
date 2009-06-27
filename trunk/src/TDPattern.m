//
//  TDPattern.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDPattern.h>
#import "RegexKitLite.h"

@interface TDPattern ()
@property (nonatomic, assign) TDTokenType tokenType;
@end

@implementation TDPattern

+ (id)patternWithString:(NSString *)s {
    return [self patternWithString:s options:TDPatternOptionsNone];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts {
    return [self patternWithString:s options:opts tokenType:TDTokenTypeAny];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t {
    return [[[self alloc] initWithString:s options:opts tokenType:t] autorelease];
}


- (id)initWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t {
    if (self = [super initWithString:s]) {
        options = opts;
        tokenType = t;
    }
    return self;
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (TDTokenTypeAny != tokenType && tok.tokenType != tokenType) {
        return NO;
    }
    
    NSRange r = NSMakeRange(0, tok.stringValue.length);

    BOOL isMatch = NSEqualRanges(r, [tok.stringValue rangeOfRegex:self.string options:(uint32_t)options inRange:r capture:0 error:nil]);
    if (inverted) {
        return !isMatch;
    } else {
        return isMatch;
    }
}


- (id)invertedPattern {
    TDPattern *pattern = [[self class] patternWithString:self.string options:options tokenType:tokenType];
    pattern->inverted = !inverted;
    return pattern;
}

@synthesize tokenType;
@end
