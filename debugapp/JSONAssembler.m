//
//  JSONAssembler.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "JSONAssembler.h"
#import "NSArray+TDParseKitAdditions.h"
#import <TDParseKit/TDParseKit.h>

@implementation JSONAssembler

- (id)init {
    self = [super init];
    if (self != nil) {
        
        NSFont *monaco = [NSFont fontWithName:@"Monaco" size:11.];
        self.defaultAttrs       = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor whiteColor], NSForegroundColorAttributeName,
                                   [NSColor blackColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];
        self.objectAttrs        = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor redColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];
        self.arrayAttrs         = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor blueColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];
        self.propertyNameAttrs  = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor purpleColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];
        self.valueAttrs         = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor orangeColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];
        self.constantAttrs      = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor yellowColor], NSForegroundColorAttributeName,
                                   [NSColor blackColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];

        self.displayString = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:defaultAttrs] autorelease];
        
        self.comma = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"," floatValue:0];
        self.curly = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"{" floatValue:0];
        self.bracket = [TDToken tokenWithTokenType:TDTokenTypeSymbol stringValue:@"[" floatValue:0];
    }
    return self;
}


- (void)dealloc {
    self.displayString = nil;
    self.defaultAttrs = nil;
    self.objectAttrs = nil;
    self.arrayAttrs = nil;
    self.propertyNameAttrs = nil;
    self.valueAttrs = nil;
    self.constantAttrs = nil;
    self.comma = nil;
    self.curly = nil;
    self.bracket = nil;
    [super dealloc];
}


- (void)appendAttributedStringForObjects:(NSArray *)objs withAttrs:(id)attrs {
//    NSMutableAttributedString *mas = [[[NSMutableAttributedString alloc] init] autorelease];
    for (id obj in objs) {
        NSAttributedString *as = [[[NSAttributedString alloc] initWithString:[obj stringValue] attributes:attrs] autorelease];
        [displayString appendAttributedString:as];
    }
//    return mas;
}


- (void)workOnStartAssembly:(TDAssembly *)a {

}


- (void)consumeWhitespaceFrom:(TDAssembly *)a {
    NSMutableArray *whitespaceToks = [NSMutableArray array];
    TDToken *tok = nil;
    while (1) {
        tok = [a pop];
        if (TDTokenTypeWhitespace == tok.tokenType) {
            [whitespaceToks addObject:tok];
        } else {
            [a push:tok];
            break;
        }
    }
    
    if (whitespaceToks.count) {
        whitespaceToks = [whitespaceToks reversedMutableArray];
    }
    
    [self appendAttributedStringForObjects:whitespaceToks withAttrs:defaultAttrs];
}


- (void)workOnSymbolCharAssembly:(TDAssembly *)a {
    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self consumeWhitespaceFrom:a];
    [self appendAttributedStringForObjects:objs withAttrs:objectAttrs];
}


- (void)workOnPropertyNameAssembly:(TDAssembly *)a {
    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self appendAttributedStringForObjects:objs withAttrs:propertyNameAttrs];
}


- (void)workOnStringAssembly:(TDAssembly *)a {
    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self appendAttributedStringForObjects:objs withAttrs:arrayAttrs];
}


- (void)workOnNumberAssembly:(TDAssembly *)a {
    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self appendAttributedStringForObjects:objs withAttrs:valueAttrs];
}


- (void)workOnCommaValueAssembly:(TDAssembly *)a {
//    NSArray *objs = [a objectsAbove:comma];
//    [self appendAttributedStringForObjects:objs withAttrs:arrayAttrs];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self appendAttributedStringForObjects:objs withAttrs:constantAttrs];
}

@synthesize displayString;
@synthesize defaultAttrs;
@synthesize objectAttrs;
@synthesize arrayAttrs;
@synthesize propertyNameAttrs;
@synthesize valueAttrs;
@synthesize constantAttrs;
@synthesize comma;
@synthesize curly;
@synthesize bracket;
@end

