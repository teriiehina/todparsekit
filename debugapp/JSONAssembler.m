//
//  JSONAssembler.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "JSONAssembler.h"
#import <TDParseKit/TDParseKit.h>

@implementation JSONAssembler

- (id)init {
    self = [super init];
    if (self != nil) {
        self.defaultAttrs       = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor whiteColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
        self.objectAttrs        = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor redColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
        self.arrayAttrs         = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor blueColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
        self.propertyNameAttrs  = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor purpleColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
        self.valueAttrs         = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor orangeColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
        self.constantAttrs      = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSColor yellowColor], NSForegroundColorAttributeName,
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   nil];
    }
    return self;
}


- (void)dealloc {
    self.defaultAttrs = nil;
    self.objectAttrs = nil;
    self.arrayAttrs = nil;
    self.propertyNameAttrs = nil;
    self.valueAttrs = nil;
    self.constantAttrs = nil;
    [super dealloc];
}


- (void)workOnStartAssembly:(TDAssembly *)a {
    
}


- (void)workOnObjectAssembly:(TDAssembly *)a {
    
}


- (void)workOnPropertyAssembly:(TDAssembly *)a {
    
}


- (void)workOnCommaPropertyAssembly:(TDAssembly *)a {
    
}


- (void)workOnArrayAssembly:(TDAssembly *)a {
    
}


- (void)workOnValueAssembly:(TDAssembly *)a {
    
}


- (void)workOnCommaValueAssembly:(TDAssembly *)a {
    
}


- (void)workOnNullAssembly:(TDAssembly *)a {
    [self workOnConstantAssembly:a];
}


- (void)workOnTrueAssembly:(TDAssembly *)a {
    [self workOnConstantAssembly:a];
}


- (void)workOnFalseAssembly:(TDAssembly *)a {
    [self workOnConstantAssembly:a];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
//    TDToken *tok = [a pop];
//    NSAttributedString *as = [[NSMutableAttributedString alloc] initWithString:tok.stringValue attributes:constantAttrs];
//    [a push:as];
//    [as release];
}


@synthesize defaultAttrs;
@synthesize objectAttrs;
@synthesize arrayAttrs;
@synthesize propertyNameAttrs;
@synthesize valueAttrs;
@synthesize constantAttrs;
@end

