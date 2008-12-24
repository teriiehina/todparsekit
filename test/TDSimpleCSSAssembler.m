//
//  TDSimpleCSSAssembler.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/23/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSimpleCSSAssembler.h"
#import "NSString+TDParseKitAdditions.h"
#import <TDParseKit/TDParseKit.h>

@implementation TDSimpleCSSAssembler

- (id)init {
    self = [super init];
    if (self) {
        self.properties = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.properties = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Assembler Callbacks

// @start      = ruleset*;
// ruleset     = selector '{' decls '}'.discard;
// selector    = LowercaseWord;            // forcing selectors to be lowercase words for use in a future syntax-highlight framework where i want that
// decls       = Empty | actualDecls;
// actualDecls = decl decl*;
// decl        = property ':'.discard expr ';'?;
// property    = 'color' | 'background-color' | 'font-weight' | 'font-style' | 'font-family' | 'font-size';
// expr        = hexcolor | string
// hexcolor    = '#'.discard Num
// string      = QuotedString

- (void)workOnStringAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    [a push:[tok.stringValue stringByRemovingFirstAndLastCharacters]];
}


- (void)workOnHexcolorAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    NSString *s = tok.stringValue;
    NSColor *color = nil;

    if (6 == s.length) {
        NSString *redStr   = [s substringWithRange:NSMakeRange(0, 2)];
        NSString *greenStr = [s substringWithRange:NSMakeRange(2, 4)];
        NSString *blueStr  = [s substringWithRange:NSMakeRange(4, 6)];
        
        redStr   = [NSString stringWithFormat:@"0x00%@" redStr];
        greenStr = [NSString stringWithFormat:@"0x00%@" greenStr];
        blueStr  = [NSString stringWithFormat:@"0x00%@" blueStr];
        
        CGFloat red   = [redStr doubleValue];
        CGFloat green = [greenStr doubleValue];
        CGFloat blue  = [blueStr doubleValue];
        
        color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
    } else {
        color = [NSColor magentaColor]; // signals incorrect value in stylesheet
    }
    [a push:];
}


- (void)workOnExprAssembly:(TDAssembly *)a {
    TDToken *tok = [a pop];
    
}


- (void)workOnDeclAssembly:(TDAssembly *)a {
    NSMutableDictionary *d = a.target;
    if (!d) {
        d = [NSMutableDictionary dictionary];
        a.target = d;
    }
    id propVal = [a pop];
    id propName = [a pop];
    [d setObject:propVal forKey:propName];
}


@synthesize properties;
@end
