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
    PKAssembly *result = [p completeMatchFor:a];
    
    // -[PKParser completeMatchFor:]
    // -[PKParser bestMatchFor:]
    // -[PKParser matchAndAssemble:]
    // -[TDTerminal allMatchesFor:]
    // -[TDTerminal matchOneAssembly:]
    // -[TDLiteral qualifies:]
    // -[PKParser best:]
    
    NSLog(@"result: %@", result);
    TDNotNil(result);
    TDEqualObjects(@"[123]123^", [result description]);
}


- (void)testFalseCompleteMatchForLiteral123 {
    s = @"1234";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"123"];
    PKAssembly *result = [p completeMatchFor:a];
    TDNil(result);
    TDEqualObjects(@"[]^1234", [a description]);
}


- (void)testTrueCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"Foo"];
    PKAssembly *result = [p completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[Foo]Foo^", [result description]);
}


- (void)testFalseCompleteMatchForLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDLiteral literalWithString:@"foo"];
    PKAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}


- (void)testFalseCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Fool";
    a = [[TDTokenAssembly alloc] initWithString:s];
    
    p = [TDCaseInsensitiveLiteral literalWithString:@"Foo"];
    PKAssembly *result = [p completeMatchFor:a];
    TDNil(result);
}


- (void)testTrueCompleteMatchForCaseInsensitiveLiteralFoo {
    s = @"Foo";
    a = [[TDTokenAssembly alloc] initWithString:s];
        
    p = [TDCaseInsensitiveLiteral literalWithString:@"foo"];
    PKAssembly *result = [p completeMatchFor:a];
    TDNotNil(result);
    TDEqualObjects(@"[Foo]Foo^", [result description]);
}

@end
