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
#import "EBNFParser.h"
#import "TDPlistParser.h"
#import "TDXmlNameState.h"
#import "TDXmlToken.h"
#import "TDHtmlSyntaxHighlighter.h"
#import "TDGrammarParserFactory.h"
#import "JSONAssembler.h"
#import "NSArray+TDParseKitAdditions.h"

@interface TDGrammarParserFactory ()
- (TDSequence *)parserForExpression:(NSString *)s;
@property (retain) TDCollectionParser *expressionParser;
@end

@implementation DebugAppDelegate

- (void)dealloc {
    self.displayString = nil;
    [super dealloc];
}


- (void)doPlistParser {
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
}


- (void)doHtmlSyntaxHighlighter {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"nyt" ofType:@"html"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    //NSString *s = @"ア";
    
    TDHtmlSyntaxHighlighter *highlighter = [[TDHtmlSyntaxHighlighter alloc] initWithAttributesForDarkBackground:YES];
    NSAttributedString *o = [highlighter attributedStringForString:s];
    //NSLog(@"o: %@", [o string]);
    self.displayString = o;
    [highlighter release];    
}


- (void)doJsonParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    
    TDJsonParser *p = [[[TDJsonParser alloc] init] autorelease];
//    TDFastJsonParser *p = [[[TDFastJsonParser alloc] init] autorelease];
    
    id result = nil;
    
    @try {
        result = [p parse:s];
    } @catch (NSException *e) {
        NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
    }
    NSLog(@"result %@", result);
}


- (void)doEBNFParser {
    //NSString *s = @"foo (bar|baz)*;";
    NSString *s = @"$baz = bar; ($baz|foo)*;";
    //NSString *s = @"foo;";
    EBNFParser *p = [[[EBNFParser alloc] init] autorelease];
    
    //    TDAssembly *a = [p bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    //    NSLog(@"a: %@", a);
    //    NSLog(@"a.target: %@", a.target);
    
    TDParser *res = [p parse:s];
    //    NSLog(@"res: %@", res);
    //    NSLog(@"res: %@", res.string);
    //    NSLog(@"res.subparsers: %@", res.subparsers);
    //    NSLog(@"res.subparsers 0: %@", [[res.subparsers objectAtIndex:0] string]);
    //    NSLog(@"res.subparsers 1: %@", [[res.subparsers objectAtIndex:1] string]);
    
    s = @"bar foo bar foo";
    TDAssembly *a = [res completeMatchFor:[TDTokenAssembly assemblyWithString:s]];
    NSLog(@"\n\na: %@\n\n", a);
}


- (void)doGrammarParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"grammar"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];

    JSONAssembler *assembler = [[[JSONAssembler alloc] init] autorelease];
    TDParser *lp = [factory parserForGrammar:s assembler:assembler];

    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [lp completeMatchFor:a];
    id res = [a pop];
    NSLog(@"res: %@", res);
    NSArray *strings = [[a objectsAbove:nil] reversedArray];
    NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] init] autorelease];
    for (id obj in strings) {
        [as appendAttributedString:obj];
    }
    self.displayString = as;
}


- (void)workOnStartAssembly:(TDAssembly *)a {
    
    
}


- (IBAction)run:(id)sender {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
//    [self doPlistParser];
//    [self doHtmlSyntaxHighlighter];
//    [self doJsonParser];
//    [self doGrammarParser];

    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];
//    TDParser *p = [factory parserForExpression:s];
    
    NSString *s = @" start = foo; foo = 'bar';";
    TDParser *p = [factory parserForGrammar:s assembler:nil];

    
    [pool release];
    
}

@synthesize displayString;
@end
