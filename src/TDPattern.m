//
//  TDPattern.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDPattern.h>
#import "RegexKitLite.h"

@implementation TDPattern

+ (id)patternWithString:(NSString *)s {
    return [self patternWithString:s options:TDPatternOptionsNone];
}


+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts {
    return [[[self alloc] initWithString:s options:opts] autorelease];
}


- (id)initWithString:(NSString *)s {
    return [self initWithString:s options:TDPatternOptionsNone];
}

    
- (id)initWithString:(NSString *)s options:(TDPatternOptions)opts {
    if (self = [super initWithString:s]) {
        options = opts;
    }
    return self;
}


- (BOOL)qualifies:(id)obj {
    PKToken *tok = (PKToken *)obj;

    NSRange r = NSMakeRange(0, tok.stringValue.length);

    BOOL isMatch = NSEqualRanges(r, [tok.stringValue rangeOfRegex:self.string options:(uint32_t)options inRange:r capture:0 error:nil]);
    if (inverted) {
        return !isMatch;
    } else {
        return isMatch;
    }
}


- (id)invertedPattern {
    TDPattern *pattern = [[self class] patternWithString:self.string options:options];
    pattern->inverted = !inverted;
    return pattern;
}

@end
