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
    TDNotNil(res);

    id obj = [res pop];
    TDNotNil(obj);
    TDTrue([obj isKindOfClass:[NSDictionary class]]);
    TDEquals((NSUInteger)6, [obj count]);
    
    id arr = [obj objectForKey:@"ArrayKey"];
    TDNotNil(arr);
    TDEquals((NSUInteger)3, [arr count]);
    
    id b = [obj objectForKey:@"YESKey"];
    TDNotNil(b);
    TDEqualObjects([NSNumber numberWithInteger:1], b);
}


- (void)testARealDict2 {
    //NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
    //                   [NSNumber numberWithBool:NO], @"NO Key",
    //                   [NSNumber numberWithBool:YES], @"YESKey",
    //                   [NSNumber numberWithInteger:1], @"IntegerKey",
    //                   [NSNumber numberWithFloat:1.0], @"1.0",
    //                   [NSNumber numberWithInteger:0], @"0",
    //                   [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:47],
    //                   [NSNumber numberWithInteger:0], [NSNumber numberWithFloat:47.7],
    //                   @"String", @"StringKey",
    //                   [NSNull null], @"Null Key",
    //                   [NSNull null], [NSNull null],
    //                   [NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"], @"dictKey",
    //                   [NSDictionary dictionary], @"emptyDictKey",
    //                   [NSArray arrayWithObjects:@"one one", @"two", @"three", nil], @"ArrayKey",
    //                   nil];
    //NSLog(@"%@", d);
    
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
    TDNotNil(res);
    
    id obj = [res pop];
    TDNotNil(obj);
    TDTrue([obj isKindOfClass:[NSDictionary class]]);
    TDEquals((NSUInteger)13, [obj count]);
    
    id arr = [obj objectForKey:@"ArrayKey"];
    TDNotNil(arr);
    TDEquals((NSUInteger)3, [arr count]);
    
    id b = [obj objectForKey:@"YESKey"];
    TDNotNil(b);
    TDEqualObjects([NSNumber numberWithInteger:1], b);
}


- (void)testDictFooEqBar {
    s = @"{foo = bar;}";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.dictParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnDictionaryAssembly: has already executed. 
    id obj = [res pop]; // NSDictionary *
    TDTrue([obj isKindOfClass:[NSDictionary class]]);
    TDEquals((NSUInteger)1, [obj count]);
    
    TDEqualObjects(@"bar", [obj objectForKey:@"foo"]);
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
    TDNotNil(res);
    
    // -workOnDictionaryAssembly: has already executed. 
    id obj = [res pop]; // NSDictionary *
    TDTrue([obj isKindOfClass:[NSDictionary class]]);
    TDEquals((NSUInteger)2, [obj count]);
    
    TDEqualObjects(@"bar", [obj objectForKey:@"foo foo"]);    
    TDEqualObjects([NSNumber numberWithFloat:2.2], [obj objectForKey:[NSNumber numberWithInteger:1]]);
}


- (void)testKeyValuePairFooEqBar {
    s = @"foo = bar;";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.keyValuePairParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnKeyValuePairAssembly: has already executed. 
    id value = [res pop]; // NSString *
    id key = [res pop]; // NSString *
    
    TDTrue([key isKindOfClass:[NSString class]]);
    TDEqualObjects(@"foo", key);
    
    TDTrue([value isKindOfClass:[NSString class]]);
    TDEqualObjects(@"bar", value);
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
    TDNotNil(res);
    
    // -workOnNumberAssembly: has already executed. 
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEquals(1, [obj integerValue]);
}


- (void)testCommaValueCommaFoo {
    s = @", Foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.commaValueParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnWordAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    TDTrue([obj isKindOfClass:[NSString class]]);
    TDEqualObjects(@"Foo", obj);
}


- (void)testCommaValueCommaQuoteFooSpaceBarQuote {
    s = @", \"Foo Bar\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.commaValueParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnQuotedStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    TDTrue([obj isKindOfClass:[NSString class]]);
    TDEqualObjects(@"Foo Bar", obj);
}


- (void)testArrayEmptyArray {
    s = @"()";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.arrayParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnArrayAssembly: has already executed. 
    id obj = [res pop]; // NSArray *
    TDTrue([obj isKindOfClass:[NSArray class]]);
    TDEquals((NSUInteger)0, [obj count]);
}


- (void)testArrayNumArray {
    s = @"(1, 2, 3)";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.arrayParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnArrayAssembly: has already executed. 
    id obj = [res pop]; // NSArray *
    TDTrue([obj isKindOfClass:[NSArray class]]);
    TDEquals((NSUInteger)3, [obj count]);
    TDEqualObjects([NSNumber numberWithInt:1], [obj objectAtIndex:0]);
    TDEqualObjects([NSNumber numberWithInt:2], [obj objectAtIndex:1]);
    TDEqualObjects([NSNumber numberWithInt:3], [obj objectAtIndex:2]);
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
    TDNotNil(res);
    
    // -workOnNullAssembly: has already executed. 
    id obj = [res pop]; // NSNull *
    TDTrue([obj isKindOfClass:[NSNull class]]);
    TDEqualObjects([NSNull null], obj);
}


- (void)testNullQuoteLtNullGtQuote {
    s = @"\"<null>\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.nullParser completeMatchFor:a];
    TDNil(res);
}


- (void)testStringQuote1Dot0Quote {
    s = @"\"1.0\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    TDTrue([obj isKindOfClass:[NSString class]]);
    TDEqualObjects(@"1.0", obj);
}


- (void)testStringFoo {
    s = @"foo";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    TDTrue([obj isKindOfClass:[NSString class]]);
    TDEqualObjects(@"foo", obj);
}


- (void)testStringQuoteFooQuote {
    s = @"\"foo\"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.stringParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnStringAssembly: has already executed. 
    id obj = [res pop]; // NSString *
    TDTrue([obj isKindOfClass:[NSString class]]);
    TDEqualObjects(@"foo", obj);
}


- (void)testNum1Dot0 {
    s = @"1.0";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"1", [obj stringValue]);
    TDEquals(1, [obj integerValue]);
    TDEquals(1.0f, [obj floatValue]);
}


- (void)testNumMinus1Dot0 {
    s = @"-1.0";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"-1", [obj stringValue]);
    TDEquals(-1, [obj integerValue]);
    TDEquals(-1.0f, [obj floatValue]);
}


- (void)testNumMinus1 {
    s = @"-1";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"-1", [obj stringValue]);
    TDEquals(-1, [obj integerValue]);
    TDEquals(-1.0f, [obj floatValue]);
}


- (void)testNum0 {
    s = @"0";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"0", [obj stringValue]);
    TDEquals(0, [obj integerValue]);
    TDEquals(0.0f, [obj floatValue]);
}


- (void)testNum0Dot0 {
    s = @"0.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"0", [obj stringValue]);
    TDEquals(0, [obj integerValue]);
    TDEquals(0.0f, [obj floatValue]);
}


- (void)testNumMinus0Dot0 {
    s = @"-0.0";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"-0", [obj stringValue]);
    TDEquals(-0, [obj integerValue]);
    TDEquals(-0.0f, [obj floatValue]);
}


- (void)testNum300 {
    s = @"300";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNotNil(res);
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    TDTrue([obj isKindOfClass:[NSNumber class]]);
    TDEqualObjects(@"300", [obj stringValue]);
    TDEquals(300, [obj integerValue]);
    TDEquals(300.0f, [obj floatValue]);
}


- (void)testNumEmptyString {
    s = @"";
    p.tokenizer.string = s;
    a = [TDTokenAssembly assemblyWithTokenizer:p.tokenizer];
    res = [p.numParser completeMatchFor:a];
    TDNil(res);
}

@end