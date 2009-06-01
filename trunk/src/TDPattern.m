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
    return [self patternWithString:s options:RKLNoOptions];
}


+ (id)patternWithString:(NSString *)s options:(RKLRegexOptions)opts {
    return [self patternWithString:s options:opts tokenType:TDTokenTypeAny];
}


+ (id)patternWithString:(NSString *)s options:(RKLRegexOptions)opts tokenType:(TDTokenType)t {
    return [self patternWithString:s options:opts tokenType:TDTokenTypeAny inRange:NSMakeRange(0, NSUIntegerMax)];
}


+ (id)patternWithString:(NSString *)s options:(RKLRegexOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r {
    return [[[self alloc] initWithString:s options:opts tokenType:t inRange:r] autorelease];
}


- (id)initWithString:(NSString *)s options:(RKLRegexOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r; {
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
    
    return [tok.stringValue isMatchedByRegex:self.string options:options inRange:range error:nil];
}

@end
