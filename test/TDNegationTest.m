//
//  TDNegationTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDNegationTest.h"

@implementation TDNegationTest

- (void)testFoo {
    PKNegation *n = [PKNegation negationWithSubparser:[PKWord word]];
    
    s = @"bar";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [n bestMatchFor:a];
    TDNil(res);

    s = @"'foo'";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [n bestMatchFor:a];
    TDEqualObjects(@"['foo']'foo'^", [res description]);

    n = [PKNegation negationWithSubparser:[PKLiteral literalWithString:@"foo"]];
    
    s = @"foo";
    a = [PKTokenAssembly assemblyWithString:s];
    res = [n bestMatchFor:a];
    TDNil(res);
    
}    
    
@end
