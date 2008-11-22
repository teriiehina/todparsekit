//
//  TDLiteralTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLiteralTest.h"


@implementation TDLiteralTest

- (void)tearDown {
    [a release];    
}

- (void)testTrueCompleteMatchForLiteral123 {
    s = @"123";
    a = [[TDTokenAssembly alloc] initWithString:s];
    NSLog(@"a: %@", a);
    
    p = [TDNum num];
    TDAssembly *result = [p completeMatchFor:a];
    
    // -[TDParser completeMatchFor:]
    // -[TDParser bestMatchFor:]
    // -[TDParser matchAndAssemble:]
    // -[TDTerminal allMatchesFor:]
    // -[TDTerminal matchOneAssembly:]
    // -[TDLiteral qualifies:]
    // -[TDParser best:]
    
    NSLog(@"result: %@", result);
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[123]123^", [result description], @"");
}


- (void)testFalseCompleteMatchForLiteral123 {
    s = @"1234";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"123"];
    TDAssembly *result = [p completeMatchFor:a];
    STAssertNil(result, @"");
    STAssertEqualObjects(@"[]^1234", [a description], @"");
}


- (void)testTrueCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"Foo"];
    TDAssembly *result = [p completeMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[Foo]Foo^", [result description], @"");
}


- (void)testFalseCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"foo"];
    TDAssembly *result = [p completeMatchFor:a];
    STAssertNil(result, @"");
}


- (void)testFalseCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Fool";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDCaseInsensitiveLiteral literalWithString:@"Foo"];
    TDAssembly *result = [p completeMatchFor:a];
    STAssertNil(result, @"");
}


- (void)testTrueCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
        
    p = [TDCaseInsensitiveLiteral literalWithString:@"foo"];
    TDAssembly *result = [p completeMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[Foo]Foo^", [result description], @"");
}

@end
