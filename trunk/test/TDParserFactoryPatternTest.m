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
    g = @"@start = Pattern('foo', '', Any);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);


    g = @"@start = Pattern('fo+', '', Any);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);

    
    g = @"@start = Pattern('[fo]+', '', Any);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);


    g = @"@start = Pattern('\\w+', '', Any);";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);
//
//
//    g = @"@start = Pattern('foo' 'i', Any);";
//    lp = [factory parserFromGrammar:g assembler:nil];
//    TDNotNil(lp);
//    
//    s = @"FOO";
//    res = [lp bestMatchFor:[TDTokenAssembly assemblyWithString:s]];
//    TDEqualObjects(@"[FOO]FOO^", [res description]);
}

@end
