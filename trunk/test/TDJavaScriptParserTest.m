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


//- (void)testFoo {
//    s = @"var foo = 'bar';";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
////    res = [jsp completeMatchFor:a];
////    TDEqualObjects([res description], @"[var, foo, =, 'bar', ;]var/foo/=/'bar'/;^");
//}
//
//
//- (void)testSemi {
//    s = @";";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
////    res = [jsp completeMatchFor:a];
////    TDEqualObjects([res description], @"[;];^");
//}
//
//
//- (void)testString {
//    s = @"'bar'";
//    jsp.tokenizer.string = s;
//    a = [TDTokenAssembly assemblyWithTokenizer:jsp.tokenizer];
////    res = [jsp completeMatchFor:a];
////    TDEqualObjects([res description], @"['bar']'bar'^");
//}

@end
