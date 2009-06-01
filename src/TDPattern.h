//
//  TDPattern.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>
#import <TDParseKit/TDToken.h>

typedef enum {
    TDPatternOptionsNone              = 0,
    TDPatternOptionsIgnoreCase             = 2,
    TDPatternOptionsComments               = 4,
    TDPatternOptionsDotAll                 = 32,
    TDPatternOptionsMultiline              = 8,
    TDPatternOptionsUnicodeWordBoundaries  = 256
} TDPatternOptions;

@interface TDPattern : TDTerminal {
    uint32_t options; // RKLRegexOptions
    TDTokenType tokenType;
    NSRange range;
    BOOL inverted;
}
+ (id)patternWithString:(NSString *)s;

+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts;

+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t;

+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r;

- (id)initWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t inRange:(NSRange)r;

- (void)invert;

- (id)invertedPattern;
@end
