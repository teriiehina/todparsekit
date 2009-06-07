//
//  TDParserFactoryPatternTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/6/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParserFactoryPatternTest.h"

@implementation TDParserFactoryPatternTest

- (void)setUp {
    factory = [TDParserFactory factory];
}


- (void)test1 {
    g = @"@start = /foo/;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);


    g = @"@start = /fo+/;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);

    
    g = @"@start = /[fo]+/;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);


//    g = @"@start = /\\w+/;";
//    lp = [factory parserFromGrammar:g assembler:nil];
//    TDNotNil(lp);
//    
//    s = @"foo";
//    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
//    TDEqualObjects(@"[foo]foo^", [res description]);
}

@end
