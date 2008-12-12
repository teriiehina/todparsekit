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

    
//    
//    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
//    NSString *s = [NSString stringWithContentsOfFile:path];
//    
//    TDJsonParser *p = [[[TDJsonParser alloc] init] autorelease];
////    TDFastJsonParser *p = [[[TDFastJsonParser alloc] init] autorelease];
//    
//    id result = nil;
//    
//    @try {
//        result = [p parse:s];
//    } @catch (NSException *e) {
//        NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
//    }
    //NSLog(@"result %@", result);

    NSString *s = nil;
    TDTokenAssembly *a = nil;
    TDAssembly *res = nil;
    TDPlistParser *p = nil;
    
    p = [[[TDPlistParser alloc] init] autorelease];

    s = @"{"
    @"    0 = 0;"
    @"    dictKey =     {"
    @"        bar = foo;"
    @"    };"
    @"    47 = 0;"
    @"    IntegerKey = 1;"
    @"    47.7 = 0;"
    @"    <null> = <null>;"
    @"    ArrayKey =     ("
    @"                    \"one one\","
    @"                    two,"
    @"                    three"
    @"                    );"
    @"    \"Null Key\" = <null>;"
    @"    emptyDictKey =     {"
    @"    };"
    @"    StringKey = String;"
    @"    \"1.0\" = 1;"
    @"    YESKey = 1;"
    @"   \"NO Key\" = 0;"
    @"}";
    
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    
    id attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSColor whiteColor], NSForegroundColorAttributeName,
                [NSFont fontWithName:@"Monaco" size:12.], NSFontAttributeName,
                nil];
    id dict = [res pop];

    s = [dict description];
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    dict = [res pop];
    
    self.displayString = [[[NSAttributedString alloc] initWithString:[dict description] attributes:attrs] autorelease];
//    TDToken *tok = [res pop];
    
    
    [pool release];
    
}

@synthesize displayString;
@end
