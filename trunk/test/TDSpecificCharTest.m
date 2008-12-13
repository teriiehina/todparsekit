//
//  TDSpecificCharTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/15/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSpecificCharTest.h"


@implementation TDSpecificCharTest

- (void)test123 {
    s = @"123";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDEqualObjects(@"[]^123", [a description]);
    p = [TDSpecificChar specificCharWithChar:'1'];
    
    result = [p bestMatchFor:a];
    TDNotNil(a);
    TDEqualObjects(@"[1]1^23", [result description]);
    TDTrue([a hasMore]);
}


- (void)testAbc {
    s = @"abc";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDEqualObjects(@"[]^abc", [a description]);
    p = [TDSpecificChar specificCharWithChar:'1'];
    
    result = [p bestMatchFor:a];
    TDNotNil(a);
    TDNil(result);
    TDTrue([a hasMore]);
}


- (void)testRepetition {
    s = @"aaa";
    a = [TDCharacterAssembly assemblyWithString:s];
    
    TDEqualObjects(@"[]^aaa", [a description]);
    p = [TDSpecificChar specificCharWithChar:'a'];
    TDParser *r = [TDRepetition repetitionWithSubparser:p];
    
    result = [r bestMatchFor:a];
    TDNotNil(a);
    TDEqualObjects(@"[a, a, a]aaa^", [result description]);
    TDFalse([result hasMore]);
}

@end
