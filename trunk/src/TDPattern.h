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
    TDPatternNoOptions              = 0,
    TDPatternIgnoreCase             = 2,
    TDPatternComments               = 4,
    TDPatternDotAll                 = 32,
    TDPatternMultiline              = 8,
    TDPatternUnicodeWordBoundaries  = 256
} TDPatternOptions;

@interface TDPattern : TDTerminal {
    uint32_t options; // RKLRegexOptions
    TDTokenType tokenType;
    NSRange range;
    BOOL inverted;
}
+ (id)patternWithString:(NSString *)s;

+ (id)patternWithString:(NSString *)s options:(uint32_t)opts;

+ (id)patternWithString:(NSString *)s options:(uint32_t)opts tokenType:(TDTokenType)t;

+ (id)patternWithString:(NSString *)s options:(uint32_t)opts tokenType:(TDTokenType)t inRange:(NSRange)r;

- (id)initWithString:(NSString *)s options:(uint32_t)opts tokenType:(TDTokenType)t inRange:(NSRange)r;

- (void)invert;

- (id)invertedPattern;
@end
