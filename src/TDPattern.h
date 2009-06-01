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
    TDPatternOptionsNone                    = 0,
    TDPatternOptionsIgnoreCase              = 2,
    TDPatternOptionsComments                = 4,
    TDPatternOptionsMultiline               = 8,
    TDPatternOptionsDotAll                  = 32,
    TDPatternOptionsUnicodeWordBoundaries   = 256
} TDPatternOptions;

@interface TDPattern : TDTerminal {
    TDPatternOptions options;
    TDTokenType tokenType;
    BOOL inverted;
}
+ (id)patternWithString:(NSString *)s;

+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts;

+ (id)patternWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t;

- (id)initWithString:(NSString *)s options:(TDPatternOptions)opts tokenType:(TDTokenType)t;

- (id)invertedPattern;
@end
