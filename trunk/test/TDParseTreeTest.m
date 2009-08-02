//
//  TDParseTreeTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParseTreeTest.h"

@implementation TDParseTreeTest

- (void)setUp {
    factory = [PKParserFactory factory];
    as = [[[PKParseTreeAssembler alloc] init] autorelease];
}


- (void)testFoo {
    g = @"@start = expr;"
        @"expr = addExpr;"
        @"addExpr = atom (('+'|'-') atom)*;"
        @"atom = Number;";
    lp = [factory parserFromGrammar:g assembler:as];
    
    lp.tokenizer.string = @"1 + 2";
    a = [PKTokenAssembly assemblyWithTokenizer:lp.tokenizer];
    res = [lp completeMatchFor:a];
    //TDEqualObjects([res description], @"[1, +, 2]1/+/2^");
    
    
}

@end
