//
//  TDParserFactoryTest2.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParserFactoryTest2.h"

@implementation TDParserFactoryTest2

- (void)setUp {
    factory = [TDParserFactory factory];
}


- (void)test1 {
    g = @"@start = (Word | Num)*;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);

    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"24.5";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[24.5]24.5^", [res description]);

    s = @"foo bar 2 baz";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, baz]foo/bar/2/baz^", [res description]);
    
    s = @"foo bar 2 4 baz";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, 4, baz]foo/bar/2/4/baz^", [res description]);
}


- (void)test2 {
    g = @"@start = (Word | Num)* QuotedString;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, 'bar']foo/'bar'^", [res description]);
    
    s = @"24.5 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[24.5, 'bar']24.5/'bar'^", [res description]);
    
    s = @"foo bar 2 baz 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, baz, 'bar']foo/bar/2/baz/'bar'^", [res description]);
    
    s = @"foo bar 2 4 baz 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, 4, baz, 'bar']foo/bar/2/4/baz/'bar'^", [res description]);
}


- (void)test3 {
    g = @"@start = (Word | Num)* '$'+ QuotedString;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo $ 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, 'bar']foo/$/'bar'^", [res description]);
    
    s = @"foo $ $ 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, $, 'bar']foo/$/$/'bar'^", [res description]);
    
    s = @"24.5 $ 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[24.5, $, 'bar']24.5/$/'bar'^", [res description]);
    
    s = @"foo bar 2 baz $ 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, baz, $, 'bar']foo/bar/2/baz/$/'bar'^", [res description]);
    
    s = @"foo bar 2 4 baz $ 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, bar, 2, 4, baz, $, 'bar']foo/bar/2/4/baz/$/'bar'^", [res description]);
}


- (void)test4 {
    g = @"@start = (Word | Num)* ('$' '%')+ QuotedString;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, 'bar']foo/$/%/'bar'^", [res description]);
    
    s = @"foo $ % $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, $, %, 'bar']foo/$/%/$/%/'bar'^", [res description]);
}


- (void)test5 {
    g = @"@start = (Word | Num)* ('$' '%')+ QuotedString;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, 'bar']foo/$/%/'bar'^", [res description]);
    
    s = @"foo $ % $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, $, %, 'bar']foo/$/%/$/%/'bar'^", [res description]);
    
    s = @"foo 33 4 $ % $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, 33, 4, $, %, $, %, 'bar']foo/33/4/$/%/$/%/'bar'^", [res description]);
    
    s = @"foo 33 bar 4 $ % $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, 33, bar, 4, $, %, $, %, 'bar']foo/33/bar/4/$/%/$/%/'bar'^", [res description]);
}


- (void)test6 {
    g = @"@start = ((Word | Num)* ('$' '%')+) | QuotedString;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"['bar']'bar'^", [res description]);
    
    s = @"foo $ % $ %";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, $, %]foo/$/%/$/%^", [res description]);
}


- (void)test7 {
    g = @"@start = ((Word | Num)* ('$' '%')+) | QuotedString+;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"'bar' 'foo'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"['bar', 'foo']'bar'/'foo'^", [res description]);
    
    s = @"foo $ % $ %";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, $, %]foo/$/%/$/%^", [res description]);

    s = @"$ % $ %";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[$, %, $, %]$/%/$/%^", [res description]);
}


- (void)test8 {
    g = @"@start = ((Word | Num)* ('$' '%')+) | QuotedString+;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"'bar' 'foo'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"['bar', 'foo']'bar'/'foo'^", [res description]);
    
    s = @"foo $ % $ %";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, $, %, $, %]foo/$/%/$/%^", [res description]);
    
    s = @"$ % $ %";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[$, %, $, %]$/%/$/%^", [res description]);
}


- (void)test9 {
    g = @"@start = Word | (Num);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"42";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[42]42^", [res description]);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);
}


- (void)test10 {
    g = @"@start = Word | (Num QuotedString);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);

    s = @"42 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[42, 'bar']42/'bar'^", [res description]);
}


- (void)test11 {
    g = @"@start = ((Word | Num)* | ('$' '%')+) QuotedString+;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);

    s = @"foo 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo, 'bar']foo/'bar'^", [res description]);
    
    s = @"$ % $ % 'bar'";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[$, %, $, %, 'bar']$/%/$/%/'bar'^", [res description]);
}


- (void)test12 {
    g = @"@delimitState = '$'; @delimitedStrings = '$' '%' nil; @start = DelimitedString('$', '%');";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"$foo%";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[$foo%]$foo%^", [res description]);
    
    
    g = @"@delimitState = '$'; @delimitedStrings = '$' '%' nil; @start = DelimitedString('$', '');";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"$foo%";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[$foo%]$foo%^", [res description]);
    
    
    g = @"@delimitState = '$'; @delimitedStrings = '$' '%' 'fo'; @start = DelimitedString('$', '%');";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"$foo%";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[$foo%]$foo%^", [res description]);

    
    g = @"@delimitState = '$'; @delimitedStrings = '$' '%' 'f'; @start = DelimitedString('$', '%');";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"$foo%";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDNil(res);
}


- (void)testWhitespace {
    g = @"@reportsWhitespaceTokens = YES; @start = 'foo' S '+' S 'bar';";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);

    s = @"foo + bar";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[foo,  , +,  , bar]foo/ /+/ /bar^", [res description]);

    s = @"foo +bar";
    t = lp.tokenizer;
    t.string = s;
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDNil(res);
}    

@end
