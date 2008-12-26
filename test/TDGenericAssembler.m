//
//  TDGenericAssembler.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/22/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDGenericAssembler.h"
#import "NSArray+TDParseKitAdditions.h"
#import <TDParseKit/TDParseKit.h>

@interface TDGenericAssembler ()
- (void)workOnProductionNamed:(NSString *)name withAssembly:(TDAssembly *)a;
- (void)appendAttributedStringForObjects:(NSArray *)objs withAttrs:(id)attrs;
- (void)consumeWhitespaceFrom:(TDAssembly *)a;
@end

@implementation TDGenericAssembler

- (id)init {
    self = [super init];
    if (self) {
        self.displayString = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil] autorelease];
        self.defaultProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSColor blackColor], NSForegroundColorAttributeName,
                                  [NSColor whiteColor], NSBackgroundColorAttributeName,
                                  [NSFont fontWithName:@"Monaco" size:11.0], NSFontAttributeName,
                                  nil];
    }
    return self;
}


- (void)dealloc {
    self.attributes = nil;
    self.defaultProperties = nil;
    self.displayString = nil;
    [super dealloc];
}


- (BOOL)respondsToSelector:(SEL)sel {
    return YES;
//    NSString *selName = NSStringFromSelector(sel);
//    if ([selName hasPrefix:@"workOn"]) {
//        return YES; //!parsing;
//    }
//    return [super respondsToSelector:sel];
}


- (void)performSelector:(SEL)sel withObject:(id)obj {
    NSString *selName = NSStringFromSelector(sel);
    NSString *prefix = @"workOn";
    NSString *suffix = @"Assembly:";

    if ([selName hasPrefix:prefix] && [selName hasSuffix:@"Assembly:"]) {
        NSInteger c = ((NSInteger)[selName characterAtIndex:prefix.length]) + 32; // lowercase
        NSRange r = NSMakeRange(prefix.length + 1, selName.length - (prefix.length + suffix.length + 1 /*:*/));
        NSString *productionName = [NSString stringWithFormat:@"%C%@", c, [selName substringWithRange:r]];
        
        [self workOnProductionNamed:productionName withAssembly:obj];
    } else {
        [super performSelector:sel withObject:obj];
    }
}


- (void)workOnProductionNamed:(NSString *)name withAssembly:(TDAssembly *)a {
    // lookup CSS values
    NSArray *objs = [a objectsAbove:nil];
    if (!objs.count) return;
    
    id props = [attributes objectForKey:name];
    if (!props) {
        props = defaultProperties;
    }

    [self consumeWhitespaceFrom:a];
    [self appendAttributedStringForObjects:objs withAttrs:props];
    
}


- (void)appendAttributedStringForObjects:(NSArray *)objs withAttrs:(id)attrs {
    for (id obj in objs) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[obj stringValue] attributes:attrs];
        [displayString appendAttributedString:as];
        [as release];
    }
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
        [self appendAttributedStringForObjects:whitespaceToks withAttrs:nil];
    }
}

@synthesize attributes;
@synthesize defaultProperties;
@synthesize displayString;
@end
