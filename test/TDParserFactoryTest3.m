//
//  PKParserFactoryTest3.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDParserFactoryTest3.h"

@implementation TDParserFactoryTest3

- (void)setUp {
    factory = [TDParserFactory factory];
}


- (void)testOrVsAndPrecendence {
    g = @" @start ( workOnFoo: ) = foo;\n"
    @"  foo = Word & /foo/ | ^Num { 1 } ( DelimitedString ( '/' , '/' ) Symbol- '%' ) * /bar/ ;";
    lp = [factory parserFromGrammar:g assembler:nil];
    TDNotNil(lp);
    
    s = @"foo";
    res = [lp completeMatchFor:[PKTokenAssembly assemblyWithString:s]];
    TDEqualObjects(@"[foo]foo^", [res description]);
}

@end
