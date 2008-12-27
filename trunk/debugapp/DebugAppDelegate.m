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
#import "TDMiniCSSAssembler.h"
#import "TDGenericAssembler.h"
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
//    s = @"@start = openCurly closeCurly; openCurly = '{'; closeCurly = '}';";
//    s = @"@start = start*; start = 'bar';";
    
    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];
    
    JSONAssembler *ass = [[[JSONAssembler alloc] init] autorelease];
    TDParser *lp = [factory parserForGrammar:s assembler:ass];
    
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
   
//    s = @"bar bar";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    a.preservesWhitespaceTokens = YES;
    //TDAssembly *res = 
    [lp completeMatchFor:a];
    
    self.displayString = ass.displayString;
}


- (void)doProf {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json_with_discards" ofType:@"grammar"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];
    TDJsonParser *p = nil;
    
    p = [[[TDJsonParser alloc] initWithIntentToAssemble:NO] autorelease];
    
    //JSONAssembler *assembler = [[[JSONAssembler alloc] init] autorelease];
    NSDate *start = [NSDate date];
    TDParser *lp = [factory parserForGrammar:s assembler:p];
    CGFloat ms4grammar = -([start timeIntervalSinceNow]);
    
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    
    start = [NSDate date];
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [lp completeMatchFor:a];
    CGFloat ms4json = -([start timeIntervalSinceNow]);

    p = [[TDJsonParser alloc] initWithIntentToAssemble:NO];
    start = [NSDate date];
    id res = [p parse:s];
    CGFloat ms4json2 = -([start timeIntervalSinceNow]);
    [p release];
    
    p = [[TDJsonParser alloc] initWithIntentToAssemble:YES];
    start = [NSDate date];
    res = [p parse:s];
    CGFloat ms4json3 = -([start timeIntervalSinceNow]);
    [p release];
    
    id fp = [[[TDFastJsonParser alloc] init] autorelease];
    start = [NSDate date];
    res = [fp parse:s];
    CGFloat ms4json4 = -([start timeIntervalSinceNow]);
    
    id attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont fontWithName:@"Monaco" size:14.], NSFontAttributeName,
                [NSColor whiteColor], NSForegroundColorAttributeName,
                nil];

    s = [NSString stringWithFormat:@"grammar parse: %f sec\n\nlp json parse: %f sec\n\np json parse (not assembled): %f sec\n\np json parse (assembled): %f sec\n\nfast json parse (assembled): %f sec\n\n %f", ms4grammar, ms4json, ms4json2, ms4json3, ms4json4, (ms4json3/ms4json4)];
    self.displayString = [[[NSMutableAttributedString alloc] initWithString:s attributes:attrs] autorelease];
}


- (void)doTokenize {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;

    NSDate *start = [NSDate date];    
    while ((tok = [t nextToken]) != eof) ;
    CGFloat secs = -([start timeIntervalSinceNow]);
    
    id attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont fontWithName:@"Monaco" size:14.], NSFontAttributeName,
                [NSColor whiteColor], NSForegroundColorAttributeName,
                nil];

    s = [NSString stringWithFormat:@"tokenize: %f", secs];
    self.displayString = [[[NSMutableAttributedString alloc] initWithString:s attributes:attrs] autorelease];
}


- (void)doSimpleCSS {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mini_css" ofType:@"grammar"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];
    
    TDMiniCSSAssembler *assembler = [[[TDMiniCSSAssembler alloc] init] autorelease];
    TDParser *lp = [factory parserForGrammar:s assembler:assembler];
    s = @"foo { color:rgb(111.0, 99.0, 255.0); }";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [lp completeMatchFor:a];
    
}


- (void)doSimpleCSS2 {
    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];

    // create CSS parser
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mini_css" ofType:@"grammar"];
    NSString *grammarString = [NSString stringWithContentsOfFile:path];
    TDMiniCSSAssembler *cssAssembler = [[[TDMiniCSSAssembler alloc] init] autorelease];
    TDParser *cssParser = [factory parserForGrammar:grammarString assembler:cssAssembler];
    
    // parse CSS
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"css"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    a = [cssParser bestMatchFor:a];
    
    // get attributes from css
    id attrs = cssAssembler.attributes;
    
    // create JSON Parser
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"json" ofType:@"grammar"];
    grammarString = [NSString stringWithContentsOfFile:path];
    TDGenericAssembler *genericAssembler = [[[TDGenericAssembler alloc] init] autorelease];

    // give it the attrs from CSS
    genericAssembler.attributes = attrs;
    TDParser *jsonParser = [factory parserForGrammar:grammarString assembler:genericAssembler];
    
    // parse JSON
    path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];

    // take care to preseve the whitespace in the JSON
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    t.whitespaceState.reportsWhitespaceTokens = YES;
    TDTokenAssembly *a1 = [TDTokenAssembly assemblyWithTokenizer:t];
    a1.preservesWhitespaceTokens = YES;
    [jsonParser completeMatchFor:a1];
    
    self.displayString = genericAssembler.displayString;
}


- (IBAction)run:(id)sender {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
//    [self doPlistParser];
//    [self doHtmlSyntaxHighlighter];
//    [self doJsonParser];
//    [self doProf];
//    [self doTokenize];
//    [self doGrammarParser];
//    [self doSimpleCSS];
    [self doSimpleCSS2];

//    TDGrammarParserFactory *factory = [TDGrammarParserFactory factory];
//    TDParser *p = [factory parserForExpression:s];
//    NSString *s = @" start = foo; foo = 'bar';";
//    TDParser *p = [factory parserForGrammar:s assembler:nil];

    
    [pool release];
}

@synthesize displayString;
@end
