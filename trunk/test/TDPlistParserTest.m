//
//  TDPlistParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDPlistParserTest.h"

@implementation TDPlistParserTest

- (void)setUp {
    p = [[TDPlistParser alloc] init];
}


- (void)tearDown {
    [p release];
}


- (void)testARealDict {
    s = @"    {"
    @"        ArrayKey =     ("
    @"                        one,"
    @"                        two,"
    @"                        three"
    @"                        );"
    @"        FloatKey = 1;"
    @"        IntegerKey = 1;"
    @"        NOKey = 0;"
    @"        StringKey = String;"
    @"        YESKey = 1;"
    @"    }";
    
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    STAssertNotNil(res, @"");

    id obj = [res pop];
    STAssertNotNil(obj, @"");
    STAssertTrue([obj isKindOfClass:[NSDictionary class]], @"");
    STAssertEquals((NSUInteger)6, [obj count], @"");
    
    id arr = [obj objectForKey:@"ArrayKey"];
    STAssertNotNil(arr, @"");
    STAssertEquals((NSUInteger)3, [arr count], @"");
    
    id b = [obj objectForKey:@"YESKey"];
    STAssertNotNil(b, @"");
    STAssertEqualObjects([NSNumber numberWithInteger:1], b, @"");
}


- (void)testARealDict2 {
    s = @"{"
    @"    0 = 0;"
    @"    dictKey =     {"
    @"        bar = foo;"
    @"    };"
    @"    47 = 0;"
    @"    IntegerKey = 1;"
    @"    47.7 = 0;"
    @"    <null> = <null>;"
    @"    ArrayKey =     ("
    @"                    \"one one\","
    @"                    two,"
    @"                    three"
    @"                    );"
    @"    \"Null Key\" = <null>;"
    @"    emptyDictKey =     {"
    @"    };"
    @"    StringKey = String;"
    @"    \"1.0\" = 1;"
    @"    YESKey = 1;"
    @"   \"NO Key\" = 0;"
    @"}";
    
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    id obj = [res pop];
    STAssertNotNil(obj, @"");
    STAssertTrue([obj isKindOfClass:[NSDictionary class]], @"");
    STAssertEquals((NSUInteger)13, [obj count], @"");
    
    id arr = [obj objectForKey:@"ArrayKey"];
    STAssertNotNil(arr, @"");
    STAssertEquals((NSUInteger)3, [arr count], @"");
    
    id b = [obj objectForKey:@"YESKey"];
    STAssertNotNil(b, @"");
    STAssertEqualObjects([NSNumber numberWithInteger:1], b, @"");
}


- (void)testDictFooEqBar {
    s = @"{foo = bar;}";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnDictionaryAssembly: has already executed. 
    id obj = [res pop]; // NSDictionary *
    STAssertTrue([obj isKindOfClass:[NSDictionary class]], @"");
    STAssertEquals((NSUInteger)1, [obj count], @"");
    
    STAssertEqualObjects(@"bar", [obj objectForKey:@"foo"], @"");
}


- (void)testDictTrackFooEqBarMisingCurly {
    s = @"{foo = bar;";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    STAssertThrowsSpecific([p.dictParser completeMatchFor:a], TDTrackException, @"");
}


- (void)testDictQuoteFooFooQuoteEqBarOneEq2 {
    s = @"{\"foo foo\" = bar; 1 = 2.2;}";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnDictionaryAssembly: has already executed. 
    id obj = [res pop]; // NSDictionary *
    STAssertTrue([obj isKindOfClass:[NSDictionary class]], @"");
    STAssertEquals((NSUInteger)2, [obj count], @"");
    
    STAssertEqualObjects(@"bar", [obj objectForKey:@"foo foo"], @"");    
    STAssertEqualObjects([NSNumber numberWithFloat:2.2], [obj objectForKey:[NSNumber numberWithInteger:1]], @"");
}


- (void)testKeyValuePairFooEqBar {
    s = @"foo = bar;";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.keyValuePairParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnKeyValuePairAssembly: has already executed. 
    id value = [res pop]; // NSString *
    id key = [res pop]; // NSString *
    
    STAssertTrue([key isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"foo", key, @"");
    
    STAssertTrue([value isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"bar", value, @"");
}


- (void)testKeyValuePairTrackFooEqBarNoSemi {
    s = @"foo = bar";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    STAssertThrowsSpecific([p.keyValuePairParser completeMatchFor:a], TDTrackException, @"");
}


- (void)testCommaValueComma1 {
    s = @", 1";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.commaValueParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumberAssembly: has already executed. 
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEquals(1, [obj integerValue], @"");
}


- (void)testCommaValueCommaFoo {
    s = @", Foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.commaValueParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnWordAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"Foo", obj, @"");
}


- (void)testCommaValueCommaQuoteFooSpaceBarQuote {
    s = @", \"Foo Bar\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.commaValueParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnQuotedStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"Foo Bar", obj, @"");
}


- (void)testArrayEmptyArray {
    s = @"()";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.arrayParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnArrayAssembly: has already executed. 
    id obj = [res pop]; // NSArray *
    STAssertTrue([obj isKindOfClass:[NSArray class]], @"");
    STAssertEquals((NSUInteger)0, [obj count], @"");
}


- (void)testArrayNumArray {
    s = @"(1, 2, 3)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.arrayParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnArrayAssembly: has already executed. 
    id obj = [res pop]; // NSArray *
    STAssertTrue([obj isKindOfClass:[NSArray class]], @"");
    STAssertEquals((NSUInteger)3, [obj count], @"");
    STAssertEqualObjects([NSNumber numberWithInt:1], [obj objectAtIndex:0], @"");
    STAssertEqualObjects([NSNumber numberWithInt:2], [obj objectAtIndex:1], @"");
    STAssertEqualObjects([NSNumber numberWithInt:3], [obj objectAtIndex:2], @"");
}


- (void)testArrayTrackNumArrayMissingParen {
    s = @"(1, 2, 3";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    STAssertThrowsSpecific([p.arrayParser completeMatchFor:a], TDTrackException, @"");
}


- (void)testArrayTrackNumArrayMissingComma {
    s = @"(1, 2 3)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    STAssertThrowsSpecific([p.arrayParser completeMatchFor:a], TDTrackException, @"");
}


- (void)testNullLtNullGt {
    s = @"<null>";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.nullParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNullAssembly: has already executed. 
    id obj = [res pop]; // NSNull *
    STAssertTrue([obj isKindOfClass:[NSNull class]], @"");
    STAssertEqualObjects([NSNull null], obj, @"");
}


- (void)testNullQuoteLtNullGtQuote {
    s = @"\"<null>\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.nullParser completeMatchFor:a];
    STAssertNil(res, @"");
}


- (void)testStringQuote1Dot0Quote {
    s = @"\"1.0\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"1.0", obj, @"");
}


- (void)testStringFoo {
    s = @"foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"foo", obj, @"");
}


- (void)testStringQuoteFooQuote {
    s = @"\"foo\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    STAssertTrue([obj isKindOfClass:[NSString class]], @"");
    STAssertEqualObjects(@"foo", obj, @"");
}


- (void)testNum1Dot0 {
    s = @"1.0";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
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
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    STAssertNil(res, @"");
}


- (void)testNumNil {
    s = nil;
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    STAssertNil(res, @"");
}

@end