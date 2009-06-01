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

@end
