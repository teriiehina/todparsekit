//
//  DebugAppDelegate.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "DebugAppDelegate.h"
#import <TDParseKit/TDParseKit.h>
#import "TDJsonParser.h"
#import "TDFastJsonParser.h"
#import "TDRegularParser.h"
#import "TDPlistParser.h"
#import "TDXmlNameState.h"
#import "TDXmlToken.h"
#import "TDHtmlSyntaxHighlighter.h"

@implementation DebugAppDelegate

- (void)dealloc {
    self.displayString = nil;
    [super dealloc];
}


- (IBAction)run:(id)sender {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
//    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"nyt" ofType:@"html"];
//    NSString *s = [NSString stringWithContentsOfFile:path];
//    //NSString *s = @"ア";
//    
//    TDHtmlSyntaxHighlighter *highlighter = [[TDHtmlSyntaxHighlighter alloc] initWithAttributesForDarkBackground:YES];
//    NSAttributedString *o = [highlighter attributedStringForString:s];
//    //NSLog(@"o: %@", [o string]);
//    self.displayString = o;
//    [highlighter release];

    
    
//    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//    NSString *s = [NSString stringWithContentsOfFile:path];
//    
//    TDJsonParser *p = [[[TDJsonParser alloc] init] autorelease];
//    TDFastJsonParser *p = [[[TDFastJsonParser alloc] init] autorelease];
    
//    id result = nil;
//    
//    @try {
//        result = [p parse:s];
//    } @catch (NSException *e) {
//        NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
//    }
//    NSLog(@"result %@", result);

    NSString *s = nil;
    TDTokenAssembly *a = nil;
    TDAssembly *res = nil;
    TDPlistParser *p = nil;
    
    p = [[[TDPlistParser alloc] init] autorelease];

    s = @", Foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.commaValueParser completeMatchFor:a];
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    
//    TDToken *tok = [res pop];
    
    
    [pool release];
    
}

@synthesize displayString;
@end
