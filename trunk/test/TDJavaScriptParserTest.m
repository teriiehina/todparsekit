//
//  TDJavaScriptParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 3/22/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJavaScriptParserTest.h"

@implementation TDJavaScriptParserTest

- (void)setUp {
    jsp = [TDJavaScriptParser parser];
}


- (void)tearDown {
    
}


- (void)testForParenParser {
    s = @"for (";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.forParenParser completeMatchFor:a];
    TDEqualObjects([res description], @"[for, (]for/(^");

    s = @"for(";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.forParenParser completeMatchFor:a];
    TDEqualObjects([res description], @"[for, (]for/(^");
}


- (void)testUndefinedParser {
    s = @"undefined";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.undefinedParser completeMatchFor:a];
    TDEqualObjects([res description], @"[undefined]undefined^");
}


- (void)testNullParser {
    s = @"null";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.nullParser completeMatchFor:a];
    TDEqualObjects([res description], @"[null]null^");
}


- (void)testFalseParser {
    s = @"false";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.falseParser completeMatchFor:a];
    TDEqualObjects([res description], @"[false]false^");
}


- (void)testTrueParser {
    s = @"true";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.trueParser completeMatchFor:a];
    TDEqualObjects([res description], @"[true]true^");
}


- (void)testNumberParser {
    s = @"47.2";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser completeMatchFor:a];
    TDEqualObjects([res description], @"[47.2]47.2^");

    s = @"-0.20";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser completeMatchFor:a];
    TDEqualObjects([res description], @"[-0.20]-0.20^");
    
    s = @"-0.20e6";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser completeMatchFor:a];
    TDEqualObjects([res description], @"[-0.20e6]-0.20e6^");
}


- (void)testStringParser {
    s = @"'foo'";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.stringParser completeMatchFor:a];
    TDEqualObjects([res description], @"['foo']'foo'^");
}


//- (void)testFoo {
//    s = @"var foo = 'bar';";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp completeMatchFor:a];
//    TDEqualObjects([res description], @"[var, foo, =, 'bar', ;]var/foo/=/'bar'/;^");
//}


//- (void)testSemi {
//    s = @";";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp completeMatchFor:a];
//    TDEqualObjects([res description], @"[;];^");
//}


//- (void)testString {
//    s = @"'bar'";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp completeMatchFor:a];
//    TDEqualObjects([res description], @"['bar']'bar'^");
//}

@end
