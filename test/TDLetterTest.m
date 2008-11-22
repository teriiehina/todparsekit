//
//  TDLetterTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLetterTest.h"


@implementation TDLetterTest

- (void)test123 {
    s = @"123";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    STAssertEqualObjects(@"[]^123", [a description], @"");
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    STAssertNotNil(a, @"");
    STAssertNil(result, @"");
    STAssertTrue([a hasMore], @"");
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    STAssertEqualObjects(@"[]^abc", [a description], @"");
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    STAssertNotNil(a, @"");
    STAssertEqualObjects(@"[a]a^bc", [result description], @"");
    STAssertTrue([result hasMore], @"");
}


- (void)testRepetition {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    STAssertEqualObjects(@"[]^abc", [a description], @"");
    p = [TDLetter letter];
    TDParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    STAssertNotNil(a, @"");
    STAssertEqualObjects(@"[a, b, c]abc^", [result description], @"");
    STAssertFalse([result hasMore], @"");
}

@end
