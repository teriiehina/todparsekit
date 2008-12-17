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
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
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
                                   [NSColor clearColor], NSBackgroundColorAttributeName,
                                   monaco, NSFontAttributeName,
                                   nil];

        self.displayString = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:defaultAttrs] autorelease];
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
    [super dealloc];
}


- (void)colorWithAssembly:(TDAssembly *)a attrs:(id)attrs {
    NSArray *objs = [[a objectsAbove:nil] reversedArray];
    for (id obj in objs) {
        if ([obj isMemberOfClass:[TDToken class]]) {
            obj = [[[NSAttributedString alloc] initWithString:[obj stringValue] attributes:attrs] autorelease];
        } 
        [a push:obj];
    }    
}


- (void)workOnStartAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:objectAttrs];
}


- (void)workOnObjectAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:objectAttrs];
}


- (void)workOnPropertyAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:propertyNameAttrs];
}


- (void)workOnCommaPropertyAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:propertyNameAttrs];
}


- (void)workOnArrayAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:arrayAttrs];
}


- (void)workOnValueAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:valueAttrs];
}


- (void)workOnCommaValueAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:valueAttrs];
}


- (void)workOnConstantAssembly:(TDAssembly *)a {
    [self colorWithAssembly:a attrs:constantAttrs];
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

@synthesize displayString;
@synthesize defaultAttrs;
@synthesize objectAttrs;
@synthesize arrayAttrs;
@synthesize propertyNameAttrs;
@synthesize valueAttrs;
@synthesize constantAttrs;
@end

