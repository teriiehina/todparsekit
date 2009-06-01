//
//  TDPattern.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDPattern.h>
#import "RegexKitLite.h"

@implementation TDPattern

+ (id)patternWithString:(NSString *)s {
    return [self patternWithString:s options:TDPatternNoOptions];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts {
    return [self patternWithString:s options:opts tokenType:TDTokenTypeAny];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t {
    return [self patternWithString:s options:opts tokenType:t inRange:NSMakeRange(NSNotFound, 0)];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r {
    return [[[self alloc] initWithString:s options:opts tokenType:t inRange:r] autorelease];
}


- (id)initWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r {
    if (self = [super initWithString:s]) {
        options = opts;
        tokenType = t;
        range = r;
    }
    return self;
}


- (BOOL)qualifies:(id)obj {
    TDToken *tok = (TDToken *)obj;
    if (TDTokenTypeAny != tokenType && tok.tokenType != tokenType) {
        return NO;
    }
    
    NSRange r = range;
    if (NSNotFound == r.location) {
        r = NSMakeRange(0, tok.stringValue.length);
    }
    
    BOOL isMatch = NSEqualRanges(r, [tok.stringValue rangeOfRegex:self.string options:options inRange:r capture:0 error:nil]);
    if (inverted) {
        return !isMatch;
    } else {
        return isMatch;
    }
}


- (void)invert {
    inverted = !inverted;
}


- (id)invertedPattern {
    TDPattern *pattern = [[self class] patternWithString:self.string options:options tokenType:tokenType inRange:range];
    [pattern invert];
    return pattern;
}

@end
