//
//  PKAlternationTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDAlternationTest.h"

@implementation TDAlternationTest

- (void)tearDown {
    [a release];
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz {
    s = @"foo baz bar";
    a = [[PKTokenAssembly alloc] initWithString:s];
    
    p = [PKAlternation alternation];
    [p add:[PKLiteral literalWithString:@"foo"]];
    [p add:[PKLiteral literalWithString:@"bar"]];
    [p add:[PKLiteral literalWithString:@"baz"]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foo]foo^baz/bar", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz1 {
    s = @"123 baz bar";
    a = [[PKTokenAssembly alloc] initWithString:s];
    
    p = [PKAlternation alternation];
    [p add:[PKLiteral literalWithString:@"bar"]];
    [p add:[PKLiteral literalWithString:@"baz"]];
    [p add:[PKNum num]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123]123^baz/bar", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz2 {
    s = @"123 baz bar";
    a = [[PKTokenAssembly alloc] initWithString:s];
    
    p = [PKAlternation alternation];
    [p add:[PKWord word]];
    [p add:[PKLiteral literalWithString:@"baz"]];
    [p add:[PKNum num]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123]123^baz/bar", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz3 {
    s = @"123 baz bar";
    a = [[PKTokenAssembly alloc] initWithString:s];
    
    p = [PKAlternation alternation];
    [p add:[PKWord word]];
    [p add:[PKLiteral literalWithString:@"foo"]];
    [p add:[PKNum num]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123]123^baz/bar", [result description]);
}


- (void)testTrueLiteralBestMatchForFooSpaceBarSpaceBaz4 {
    s = @"123 baz bar";
    a = [[PKTokenAssembly alloc] initWithString:s];
    
    p = [PKAlternation alternation];
    [p add:[PKLiteral literalWithString:@"foo"]];
    [p add:[PKLiteral literalWithString:@"baz"]];
    [p add:[PKNum num]];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[123]123^baz/bar", [result description]);
}

@end
