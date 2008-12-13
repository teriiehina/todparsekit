//
//  TDTokenAssemblyTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenAssemblyTest.h"


@implementation TDTokenAssemblyTest

- (void)setUp {
}


- (void)tearDown {
    [p release];
}


#pragma mark -

- (void)testWordOhSpaceHaiExclamation {
    s = @"oh hai!";
    a = [TDTokenAssembly assemblyWithString:s];

    TDAssertEquals(3, a.length);

    TDAssertEquals(0, a.objectsConsumed);
    TDAssertEquals(3, a.objectsRemaining);
    TDAssertEqualObjects(@"[]^oh/hai/!", [a description]);
    TDAssertTrue([a hasMore]);
    TDAssertEqualObjects(@"oh", [[a next] stringValue]);

    TDAssertEquals(1, a.objectsConsumed);
    TDAssertEquals(2, a.objectsRemaining);
    TDAssertEqualObjects(@"[]oh^hai/!", [a description]);
    TDAssertTrue([a hasMore]);
    TDAssertEqualObjects(@"hai", [[a next] stringValue]);

    TDAssertEquals(2, a.objectsConsumed);
    TDAssertEquals(1, a.objectsRemaining);
    TDAssertEqualObjects(@"[]oh/hai^!", [a description]);
    TDAssertTrue([a hasMore]);
    TDAssertEqualObjects(@"!", [[a next] stringValue]);

    TDAssertEquals(3, a.objectsConsumed);
    TDAssertEquals(0, a.objectsRemaining);
    TDAssertEqualObjects(@"[]oh/hai/!^", [a description]);
    TDAssertFalse([a hasMore]);
    TDAssertNil([[a next] stringValue]);

    TDAssertEquals(3, a.objectsConsumed);
    TDAssertEquals(0, a.objectsRemaining);
    TDAssertEqualObjects(@"[]oh/hai/!^", [a description]);
    TDAssertFalse([a hasMore]);
    TDAssertNil([[a next] stringValue]);

    TDAssertEquals(3, a.length);
}


- (void)testBestMatchForWordFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];

    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^foobar", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[foobar]foobar^", [result description]);
    TDAssertFalse(result == a);


    result = [p bestMatchFor:result];
    TDAssertNil(result);
}


- (void)testCompleteMatchForWordFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^foobar", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertEqualObjects(@"[foobar]foobar^", [result description]);
    TDAssertFalse(result == a);
}


- (void)testBestMatchForWordFooSpaceBar {
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^foo/bar", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[foo]foo^bar", [result description]);
    TDAssertFalse(result == a);
}


- (void)testCompleteMatchForWordFooSpaceBar {
    s = @"foo bar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^foo/bar", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
}


- (void)testBestMatchForNumFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^foobar", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertNil(result);
}


- (void)testCompleteMatchForNumFoobar {
    s = @"foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^foobar", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
}


- (void)testBestMatchForWord123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^123", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertNil(result);
}


- (void)testCompleteMatchForWord123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^123", [a description]);
}


- (void)testBestMatchForNum123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^123", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[123]123^", [result description]);
    TDAssertFalse(result == a);
}


- (void)testCompleteMatchForNum123 {
    s = @"123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(1, a.length);
    TDAssertEqualObjects(@"[]^123", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[123]123^", [result description]);
    TDAssertFalse(result == a);
}


- (void)testBestMatchForNum123Space456 {
    s = @"123 456";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^123/456", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[123]123^456", [result description]);
    TDAssertFalse(result == a);
}


- (void)testCompleteMatchForNum123Space456 {
    s = @"123 456";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^123/456", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
}


- (void)testBestMatchForWordFoobarSpace123 {
    s = @"foobar 123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^foobar/123", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[foobar]foobar^123", [result description]);
    TDAssertFalse(result == a);
}


- (void)testCompleteMatchForWordFoobarSpace123 {
    s = @"foobar 123";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(2, a.length);
    TDAssertEqualObjects(@"[]^foobar/123", [a description]);
    
    p = [[TDWord alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
}


- (void)testBestMatchForNum123Space456Foobar {
    s = @"123 456 foobar";
    a = [TDTokenAssembly assemblyWithString:s];

    TDAssertEquals(3, a.length);
    TDAssertEqualObjects(@"[]^123/456/foobar", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertEqualObjects(@"[123]123^456/foobar", [result description]);
    TDAssertFalse(result == a);
}


- (void)testCompleteMatchForNum123Space456Foobar {
    s = @"123 456 foobar";
    a = [TDTokenAssembly assemblyWithString:s];
    
    TDAssertEquals(3, a.length);
    TDAssertEqualObjects(@"[]^123/456/foobar", [a description]);
    
    p = [[TDNum alloc] init];
    TDAssembly *result = [p completeMatchFor:a];
    TDAssertNil(result);
}

@end

