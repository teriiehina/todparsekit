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
    
    TDEqualObjects(@"[]^123", [a description]);
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    TDNotNil(a);
    TDNil(result);
    TDTrue([a hasMore]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDEqualObjects(@"[]^abc", [a description]);
    p = [TDLetter letter];
    
    result = [p bestMatchFor:a];
    TDNotNil(a);
    TDEqualObjects(@"[a]a^bc", [result description]);
    TDTrue([result hasMore]);
}


- (void)testRepetition {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDEqualObjects(@"[]^abc", [a description]);
    p = [TDLetter letter];
    PKParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    TDNotNil(a);
    TDEqualObjects(@"[a, b, c]abc^", [result description]);
    TDFalse([result hasMore]);
}

@end
