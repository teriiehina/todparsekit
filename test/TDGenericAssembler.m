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
    }
    return self;
}


- (void)dealloc {
    self.properties = nil;
    self.displayString = nil;
    [super dealloc];
}


- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    NSString *selName = NSStringFromSelector(sel);
    NSString *prefix = @"workOn";
    NSString *suffix = @"Assembly:";

    if ([selName hasPrefix:prefix] && [selName hasSuffix:@"Assembly:"]) {
        NSRange r = NSMakeRange(prefix.length, selName.length - suffix.length);
        NSString *productionName = [selName substringWithRange:r];
        
        TDAssembly *a = nil;
        [invocation getArgument:&a atIndex:0];
        [self workOnProductionNamed:productionName withAssembly:a];
        
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}


- (void)workOnProductionNamed:(NSString *)name withAssembly:(TDAssembly *)a {
    // lookup CSS values

    NSArray *objs = [NSArray arrayWithObject:[a pop]];
    [self consumeWhitespaceFrom:a];
    [self appendAttributedStringForObjects:objs withAttrs:nil];
    
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

@synthesize properties;
@synthesize displayString;
@end
