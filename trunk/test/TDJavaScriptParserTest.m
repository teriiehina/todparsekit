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


//- (void)testStmtParser {
//    s = @";";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp.stmtParser bestMatchFor:a];
//    TDEqualObjects([res description], @"[;];^");
//}


//- (void)testFuncParser {
//    s = @"function(a, b) {}";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp.funcParser bestMatchFor:a];
//    TDEqualObjects([res description], @"[function, (, a, ,, b, ), {, }]function/(/a/,/b/)/{/}^");
//}

- (void)testBitwiseOrExprParser {
    s = @"&& true";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp.bitwiseOrExprParser bestMatchFor:a];
//    TDEqualObjects([res description], @"[&&, true]&&/truet^");
}


- (void)testAndBitwiseOrExprParser {
    s = @"&& true";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    //res = [jsp.andBitwiseOrExprParser bestMatchFor:a];
    //TDEqualObjects([res description], @"[&&, true]&&/truet^");
}


- (void)testParamListParser {
    s = @"baz, bat";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.paramListParser bestMatchFor:a];
    TDEqualObjects([res description], @"[baz, ,, bat]baz/,/bat^");
    
    s = @"foo,bar,c_str";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.paramListParser bestMatchFor:a];
    TDEqualObjects([res description], @"[foo, ,, bar, ,, c_str]foo/,/bar/,/c_str^");

    s = @"_x, __y";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.paramListParser bestMatchFor:a];
    TDEqualObjects([res description], @"[_x, ,, __y]_x/,/__y^");
}


- (void)testCommaIdentifierParser {
    s = @", foo";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.commaIdentifierParser bestMatchFor:a];
    TDEqualObjects([res description], @"[,, foo],/foo^");

    s = @" ,bar";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.commaIdentifierParser bestMatchFor:a];
    TDEqualObjects([res description], @"[,, bar],/bar^");
}


- (void)testBreakStmtParser {
    s = @"break;";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.breakStmtParser bestMatchFor:a];
    TDEqualObjects([res description], @"[break, ;]break/;^");
}


- (void)testContinueStmtParser {
    s = @"continue;";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.continueStmtParser bestMatchFor:a];
    TDEqualObjects([res description], @"[continue, ;]continue/;^");
}


- (void)testAssignmentOpParser {
    s = @"=";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.assignmentOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[=]=^");
    
    s = @"*=";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.assignmentOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[*=]*=^");
    
    s = @"%=";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.assignmentOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[%=]%=^");
    
    s = @">>>=";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.assignmentOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[>>>=]>>>=^");
}


- (void)testRelationalOpParser {
    s = @"<=";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.relationalOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[<=]<=^");

    s = @"instanceof";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.relationalOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[instanceof]instanceof^");
}


- (void)testEqualityOpParser {
    s = @"==";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.equalityOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[==]==^");
    
    s = @"!==";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.equalityOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[!==]!==^");
    
    s = @"===";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.equalityOpParser bestMatchFor:a];
    TDEqualObjects([res description], @"[===]===^");
}


- (void)testForParenParser {
    s = @"for (";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.forParenParser bestMatchFor:a];
    TDEqualObjects([res description], @"[for, (]for/(^");

    s = @"for(";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.forParenParser bestMatchFor:a];
    TDEqualObjects([res description], @"[for, (]for/(^");
}


- (void)testUndefinedParser {
    s = @"undefined";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.undefinedParser bestMatchFor:a];
    TDEqualObjects([res description], @"[undefined]undefined^");
}


- (void)testNullParser {
    s = @"null";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.nullParser bestMatchFor:a];
    TDEqualObjects([res description], @"[null]null^");
}


- (void)testFalseParser {
    s = @"false";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.falseParser bestMatchFor:a];
    TDEqualObjects([res description], @"[false]false^");
}


- (void)testTrueParser {
    s = @"true";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.trueParser bestMatchFor:a];
    TDEqualObjects([res description], @"[true]true^");
}


- (void)testNumberParser {
    s = @"47.2";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser bestMatchFor:a];
    TDEqualObjects([res description], @"[47.2]47.2^");

    s = @"-0.20";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser bestMatchFor:a];
    TDEqualObjects([res description], @"[-0.20]-0.20^");
    
    s = @"-0.20e6";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.numberParser bestMatchFor:a];
    TDEqualObjects([res description], @"[-0.20e6]-0.20e6^");
}


- (void)testStringParser {
    s = @"'foo'";
    jsp.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
    res = [jsp.stringParser bestMatchFor:a];
    TDEqualObjects([res description], @"['foo']'foo'^");
}


//- (void)testFoo {
//    s = @"var foo = 'bar';";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp bestMatchFor:a];
//    TDEqualObjects([res description], @"[var, foo, =, 'bar', ;]var/foo/=/'bar'/;^");
//}


//- (void)testSemi {
//    s = @";";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp bestMatchFor:a];
//    TDEqualObjects([res description], @"[;];^");
//}


//- (void)testString {
//    s = @"'bar'";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
//    res = [jsp bestMatchFor:a];
//    TDEqualObjects([res description], @"['bar']'bar'^");
//}

@end
