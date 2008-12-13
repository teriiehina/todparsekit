//
//  TDDigitTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDDigitTest.h"


@implementation TDDigitTest

- (void)test123 {
    s = @"123";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^123", [a description]);
    p = [TDDigit digit];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[1]1^23", [result description]);
    TDAssertTrue([a hasMore]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^abc", [a description]);
    p = [TDDigit digit];
    
    result = [p bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertNil(result);
    TDAssertTrue([a hasMore]);
}


- (void)testRepetition {
    s = @"123";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDAssertEqualObjects(@"[]^123", [a description]);
    p = [TDDigit digit];
    TDParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    TDAssertNotNil(a);
    TDAssertEqualObjects(@"[1, 2, 3]123^", [result description]);
    TDAssertFalse([result hasMore]);
}

@end
