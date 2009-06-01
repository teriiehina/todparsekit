//
//  TDPatternTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDPatternTest.h"

@implementation TDPatternTest

- (void)testFoo {
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo" options:0];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo" options:0 tokenType:TDTokenTypeWord];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo" options:0 tokenType:TDTokenTypeWord inRange:NSMakeRange(0, 3)];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo" options:0 tokenType:TDTokenTypeWord inRange:NSMakeRange(0, 2)];
    a = [p completeMatchFor:a];
    
    TDNil(a);
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"foo" options:0 tokenType:TDTokenTypeSymbol];
    a = [p completeMatchFor:a];
    
    TDNil(a);
    
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo+"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo*"];
    a = [p completeMatchFor:a];

    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo{1,2}"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[foo]foo^");

    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"fo{3,4}"];
    a = [p completeMatchFor:a];
    
    TDNil(a);
}


- (void)testAndOrOr {
    s = @"and";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"and|or"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[and]and^");
    
    s = @"and";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"an|or"];
    a = [p completeMatchFor:a];
    
    TDNil(a);
    
    s = @"or";
    a = [TDTokenAssembly assemblyWithString:s];
    p = [TDPattern patternWithString:@"(and)|(or)"];
    a = [p completeMatchFor:a];
    
    TDNotNil(a);
    TDEqualObjects([a description], @"[or]or^");
}    

@end
