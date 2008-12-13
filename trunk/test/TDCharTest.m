//
//  TDCharTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDCharTest.h"


@implementation TDCharTest

- (void)test123 {
    s = @"123";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^123", [a description]);
    p = [TDChar char];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[1]1^23", [result description]);
    TDAssertTrue([a hasMore]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^abc", [a description]);
    p = [TDChar char];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[a]a^bc", [result description]);
    TDAssertTrue([a hasMore]);
}

- (void)testRepetition {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^abc", [a description]);
    p = [TDChar char];
    TDParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[a, b, c]abc^", [result description]);
    TDAssertFalse([result hasMore]);
}


@end
