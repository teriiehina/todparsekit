//
//  TDPlistParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDPlistParserTest.h"

@implementation TDPlistParserTest

- (void)setUp {
    p = [[TDPlistParser alloc] init];
}


- (void)tearDown {
    [p release];
}


//    {
//        ArrayKey =     (
//                        one,
//                        two,
//                        three
//                        );
//        FloatKey = 1;
//        IntegerKey = 1;
//        NOKey = 0;
//        StringKey = String;
//        YESKey = 1;
//    }

- (void)testNullLtNullGt {
    s = @"<null>";
    a = [TDTokenAssembly assemblyWithString:s];
    [p configureTokenizer:a.tokenizer];
    res = [p.nullParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNullAssembly: has already executed. 
    id obj = [res pop]; // NSNull *
    STAssertTrue([obj isKindOfClass:[NSNull class]], @"");
    STAssertEqualObjects([NSNull null], obj, @"");
}




- (void)testStringQuote1Dot0Quote {
    s = @"\"1.0\"";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"\"1.0\"", obj, @"");
}


- (void)testStringFoo {
    s = @"foo";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"foo", obj, @"");
}


- (void)testStringQuoteFooQuote {
    s = @"\"foo\"";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"\"foo\"", obj, @"");
}


- (void)testNum1Dot0 {
    s = @"1.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"1", [obj stringValue], @"");
    STAssertEquals(1, [obj integerValue], @"");
    STAssertEquals(1.0f, [obj floatValue], @"");
}


- (void)testNumMinus1Dot0 {
    s = @"-1.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"-1", [obj stringValue], @"");
    STAssertEquals(-1, [obj integerValue], @"");
    STAssertEquals(-1.0f, [obj floatValue], @"");
}


- (void)testNumMinus1 {
    s = @"-1";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"-1", [obj stringValue], @"");
    STAssertEquals(-1, [obj integerValue], @"");
    STAssertEquals(-1.0f, [obj floatValue], @"");
}


- (void)testNum0 {
    s = @"0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"0", [obj stringValue], @"");
    STAssertEquals(0, [obj integerValue], @"");
    STAssertEquals(0.0f, [obj floatValue], @"");
}


- (void)testNum0Dot0 {
    s = @"0.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"0", [obj stringValue], @"");
    STAssertEquals(0, [obj integerValue], @"");
    STAssertEquals(0.0f, [obj floatValue], @"");
}


- (void)testNumMinus0Dot0 {
    s = @"-0.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"-0", [obj stringValue], @"");
    STAssertEquals(-0, [obj integerValue], @"");
    STAssertEquals(-0.0f, [obj floatValue], @"");
}


- (void)testNum300 {
    s = @"300";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"300", [obj stringValue], @"");
    STAssertEquals(300, [obj integerValue], @"");
    STAssertEquals(300.0f, [obj floatValue], @"");
}


- (void)testNumEmptyString {
    s = @"";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNil(res, @"");
}


- (void)testNumNil {
    s = nil;
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNil(res, @"");
}

@end
