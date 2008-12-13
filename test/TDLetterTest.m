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
    
    TDAssertEqualObjects(@"[]^123", [a description]);
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertNil(result);
    TDAssertTrue([a hasMore]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^abc", [a description]);
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[a]a^bc", [result description]);
    TDAssertTrue([result hasMore]);
}


- (void)testRepetition {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^abc", [a description]);
    p = [TDLetter letter];
    TDParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[a, b, c]abc^", [result description]);
    TDAssertFalse([result hasMore]);
}

@end
