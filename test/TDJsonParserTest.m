//
//  TDJsonParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDJsonParserTest.h"
#import "TDJsonParser.h"
#import "TDFastJsonParser.h"

@implementation TDJsonParserTest

- (void)setUp {
    p = [TDJsonParser parser];
}


- (void)testForAppleBossResultTokenization {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    TDTokenizer *t = [[[TDTokenizer alloc] init] autorelease];
    t.string = s;
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    while (eof != (tok = [t nextToken])) {
        //NSLog(@"tok: %@", tok);
    }
}


- (void)testForAppleBossResult {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    
    @try {
        result = [p parse:s];
    }
    @catch (NSException *e) {
        //NSLog(@"\n\n\nexception:\n\n %@", [e reason]);
    }
    
    //NSLog(@"result %@", result);
}


- (void)testEmptyString {
    s = @"";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [p bestMatchFor:a];
    STAssertNil(result, @"");
}


- (void)testNum {
    s = @"456";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    STAssertNotNil(result, @"");

    STAssertEqualObjects(@"[456]456^", [result description], @"");
    id obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects([NSNumber numberWithFloat:456], obj, @"");

    
    s = @"-3.47";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[-3.47]-3.47^", [result description], @"");
    obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects([NSNumber numberWithFloat:-3.47], obj, @"");
}


- (void)testString {
    s = @"'foobar'";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foobar]'foobar'^", [result description], @"");
    id obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects(@"foobar", obj, @"");

    s = @"\"baz boo boo\"";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    
    STAssertEqualObjects(@"[baz boo boo]\"baz boo boo\"^", [result description], @"");
    obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects(@"baz boo boo", obj, @"");
}


- (void)testBoolean {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    STAssertNotNil(result, @"");

    STAssertEqualObjects(@"[1]true^", [result description], @"");
    id obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects([NSNumber numberWithBool:YES], obj, @"");

    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    STAssertNotNil(result, @"");

    STAssertEqualObjects(@"[0]false^", [result description], @"");
    obj = [result pop];
    STAssertNotNil(obj, @"");
    STAssertEqualObjects([NSNumber numberWithBool:NO], obj, @"");
}


- (void)testArray {
    s = @"[1, 2, 3]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    
    NSLog(@"result: %@", result);
    STAssertNotNil(result, @"");
    id obj = [result pop];
    STAssertEquals((int)3, (int)[obj count], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:1], [obj objectAtIndex:0], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:2], [obj objectAtIndex:1], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:3], [obj objectAtIndex:2], @"");
    STAssertEqualObjects(@"[][/1/,/2/,/3/]^", [result description], @"");

    s = @"[true, 'garlic jazz!', .888]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    
    //STAssertEqualObjects(@"[true, 'garlic jazz!', .888]true/'garlic jazz!'/.888^", [result description], @"");
    obj = [result pop];
    STAssertEqualObjects([NSNumber numberWithBool:YES], [obj objectAtIndex:0], @"");
    STAssertEqualObjects(@"garlic jazz!", [obj objectAtIndex:1], @"");
    STAssertEqualObjects([NSNumber numberWithFloat:.888], [obj objectAtIndex:2], @"");

    s = @"[1, [2, [3, 4]]]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    //NSLog(@"result: %@", [a stack]);
    STAssertEqualObjects([NSNumber numberWithInteger:1], [obj objectAtIndex:0], @"");
}


- (void)testObject {
    s = @"{'key': 'value'}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    
    id obj = [result pop];
    STAssertEqualObjects([obj objectForKey:@"key"], @"value", @"");

    s = @"{'foo': false, 'bar': true, \"baz\": -9.457}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    
    obj = [result pop];
    STAssertEqualObjects([obj objectForKey:@"foo"], [NSNumber numberWithBool:NO], @"");
    STAssertEqualObjects([obj objectForKey:@"bar"], [NSNumber numberWithBool:YES], @"");
    STAssertEqualObjects([obj objectForKey:@"baz"], [NSNumber numberWithFloat:-9.457], @"");

    s = @"{'baz': {'foo': [1,2]}}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    STAssertNotNil(result, @"");
    
    obj = [result pop];
    NSDictionary *dict = [obj objectForKey:@"baz"];
    STAssertTrue([dict isKindOfClass:[NSDictionary class]], @"");
    NSArray *arr = [dict objectForKey:@"foo"];
    STAssertTrue([arr isKindOfClass:[NSArray class]], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:1], [arr objectAtIndex:0], @"");
    
    //    STAssertEqualObjects(@"['baz', 'foo', 1, 2]'baz'/'foo'/1/2^", [result description], @"");
}


- (void)testCrunchBaseJsonParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    TDJsonParser *parser = [[[TDJsonParser alloc] init] autorelease];
    id res = [parser parse:s];
    res = res;
    //NSLog(@"res %@", res);
}

- (void)testCrunchBaseJsonTokenParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    TDFastJsonParser *parser = [[[TDFastJsonParser alloc] init] autorelease];
    id res = [parser parse:s];
    res = res;
    //NSLog(@"res %@", res);
}


- (void)testYahoo1 {
    s = 
    @"{"
        @"\"name\": \"Yahoo!\","
        @"\"permalink\": \"yahoo\","
        @"\"homepage_url\": \"http://www.yahoo.com\","
        @"\"blog_url\": \"http://yodel.yahoo.com/\","
        @"\"blog_feed_url\": \"http://ycorpblog.com/feed/\","
        @"\"category_code\": \"web\","
        @"\"number_of_employees\": 13600,"
        @"\"founded_year\": 1994,"
        @"\"founded_month\": null,"
        @"\"founded_day\": null,"
        @"\"deadpooled_year\": null,"
        @"\"deadpooled_month\": null,"
        @"\"deadpooled_day\": null,"
        @"\"deadpooled_url\": null,"
        @"\"tag_list\": \"search, portal, webmail, photos\","
        @"\"email_address\": \"\","
        @"\"phone_number\": \"(408) 349-3300\""
    @"}";
    result = [p parse:s];
    //NSLog(@"result %@", result);
    STAssertNotNil(result, @"");
    id d = result;
    STAssertNotNil(d, @"");
    STAssertTrue([d isKindOfClass:[NSDictionary class]], @"");
    STAssertEqualObjects([d objectForKey:@"name"], @"Yahoo!", @"");
    STAssertEqualObjects([d objectForKey:@"permalink"], @"yahoo", @"");
    STAssertEqualObjects([d objectForKey:@"homepage_url"], @"http://www.yahoo.com", @"");
    STAssertEqualObjects([d objectForKey:@"blog_url"], @"http://yodel.yahoo.com/", @"");
    STAssertEqualObjects([d objectForKey:@"blog_feed_url"], @"http://ycorpblog.com/feed/", @"");
    STAssertEqualObjects([d objectForKey:@"category_code"], @"web", @"");
    STAssertEqualObjects([d objectForKey:@"number_of_employees"], [NSNumber numberWithInteger:13600], @"");
    STAssertEqualObjects([d objectForKey:@"founded_year"], [NSNumber numberWithInteger:1994], @"");
    STAssertEqualObjects([d objectForKey:@"founded_month"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"founded_day"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"deadpooled_year"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"deadpooled_month"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"deadpooled_day"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"deadpooled_url"], [NSNull null], @"");
    STAssertEqualObjects([d objectForKey:@"tag_list"], @"search, portal, webmail, photos", @"");
    STAssertEqualObjects([d objectForKey:@"email_address"], @"", @"");
    STAssertEqualObjects([d objectForKey:@"phone_number"], @"(408) 349-3300", @"");
}


- (void)testYahoo2 {
    s = @"{\"image\":"
        @"    {\"available_sizes\":"
        @"        [[[150, 37],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-150x150.png\"],"
        @"        [[200, 50],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-250x250.png\"],"
        @"        [[200, 50],"
        @"        \"assets/images/resized/0001/0836/10836v1-max-450x450.png\"]],"
        @"    \"attribution\": null}"
        @"}";
    result = [p parse:s];
    //NSLog(@"result %@", result);

    STAssertNotNil(result, @"");

    id d = result;
    STAssertNotNil(d, @"");
    STAssertTrue([d isKindOfClass:[NSDictionary class]], @"");
    
    id image = [d objectForKey:@"image"];
    STAssertNotNil(image, @"");
    STAssertTrue([image isKindOfClass:[NSDictionary class]], @"");

    NSArray *sizes = [image objectForKey:@"available_sizes"];
    STAssertNotNil(sizes, @"");
    STAssertTrue([sizes isKindOfClass:[NSArray class]], @"");
    
    STAssertEquals(3, (int)sizes.count, @"");
    
    NSArray *first = [sizes objectAtIndex:0];
    STAssertNotNil(first, @"");
    STAssertTrue([first isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)first.count, @"");
    
    NSArray *firstKey = [first objectAtIndex:0];
    STAssertNotNil(firstKey, @"");
    STAssertTrue([firstKey isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)firstKey.count, @"");
    STAssertEqualObjects([NSNumber numberWithInteger:150], [firstKey objectAtIndex:0], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:37], [firstKey objectAtIndex:1], @"");
    
    NSArray *second = [sizes objectAtIndex:1];
    STAssertNotNil(second, @"");
    STAssertTrue([second isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)second.count, @"");
    
    NSArray *secondKey = [second objectAtIndex:0];
    STAssertNotNil(secondKey, @"");
    STAssertTrue([secondKey isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)secondKey.count, @"");
    STAssertEqualObjects([NSNumber numberWithInteger:200], [secondKey objectAtIndex:0], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:50], [secondKey objectAtIndex:1], @"");
    
    NSArray *third = [sizes objectAtIndex:2];
    STAssertNotNil(third, @"");
    STAssertTrue([third isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)third.count, @"");
    
    NSArray *thirdKey = [third objectAtIndex:0];
    STAssertNotNil(thirdKey, @"");
    STAssertTrue([thirdKey isKindOfClass:[NSArray class]], @"");
    STAssertEquals(2, (int)thirdKey.count, @"");
    STAssertEqualObjects([NSNumber numberWithInteger:200], [thirdKey objectAtIndex:0], @"");
    STAssertEqualObjects([NSNumber numberWithInteger:50], [thirdKey objectAtIndex:1], @"");
    
    
//    STAssertEqualObjects([d objectForKey:@"name"], @"Yahoo!", @"");
}


- (void)testYahoo3 {
    s = 
    @"{\"products\":"
        @"["
            @"{\"name\": \"Yahoo.com\", \"permalink\": \"yahoo-com\"},"
            @"{\"name\": \"Yahoo! Mail\", \"permalink\": \"yahoo-mail\"},"
            @"{\"name\": \"Yahoo! Search\", \"permalink\": \"yahoo-search\"},"
            @"{\"name\": \"Yahoo! Directory\", \"permalink\": \"yahoo-directory\"},"
            @"{\"name\": \"Yahoo! Finance\", \"permalink\": \"yahoo-finance\"},"
            @"{\"name\": \"My Yahoo\", \"permalink\": \"my-yahoo\"},"
            @"{\"name\": \"Yahoo! News\", \"permalink\": \"yahoo-news\"},"
            @"{\"name\": \"Yahoo! Groups\", \"permalink\": \"yahoo-groups\"},"
            @"{\"name\": \"Yahoo! Messenger\", \"permalink\": \"yahoo-messenger\"},"
            @"{\"name\": \"Yahoo! Games\", \"permalink\": \"yahoo-games\"},"
            @"{\"name\": \"Yahoo! People Search\", \"permalink\": \"yahoo-people-search\"},"
            @"{\"name\": \"Yahoo! Movies\", \"permalink\": \"yahoo-movies\"},"
            @"{\"name\": \"Yahoo! Weather\", \"permalink\": \"yahoo-weather\"},"
            @"{\"name\": \"Yahoo! Video\", \"permalink\": \"yahoo-video\"},"
            @"{\"name\": \"Yahoo! Music\", \"permalink\": \"yahoo-music\"},"
            @"{\"name\": \"Yahoo! Sports\", \"permalink\": \"yahoo-sports\"},"
            @"{\"name\": \"Yahoo! Maps\", \"permalink\": \"yahoo-maps\"},"
            @"{\"name\": \"Yahoo! Auctions\", \"permalink\": \"yahoo-auctions\"},"
            @"{\"name\": \"Yahoo! Widgets\", \"permalink\": \"yahoo-widgets\"},"
            @"{\"name\": \"Yahoo! Shopping\", \"permalink\": \"yahoo-shopping\"},"
            @"{\"name\": \"Yahoo! Real Estate\", \"permalink\": \"yahoo-real-estate\"},"
            @"{\"name\": \"Yahoo! Travel\", \"permalink\": \"yahoo-travel\"},"
            @"{\"name\": \"Yahoo! Classifieds\", \"permalink\": \"yahoo-classifieds\"},"
            @"{\"name\": \"Yahoo! Answers\", \"permalink\": \"yahoo-answers\"},"
            @"{\"name\": \"Yahoo! Mobile\", \"permalink\": \"yahoo-mobile\"},"
            @"{\"name\": \"Yahoo! Buzz\", \"permalink\": \"yahoo-buzz\"},"
            @"{\"name\": \"Yahoo! Open Search Platform\", \"permalink\": \"yahoo-open-search-platform\"},"
            @"{\"name\": \"Fire Eagle\", \"permalink\": \"fireeagle\"},"
            @"{\"name\": \"Shine\", \"permalink\": \"shine\"},"
            @"{\"name\": \"Yahoo! Shortcuts\", \"permalink\": \"yahoo-shortcuts\"}"
        @"]"
    @"}";
    result = [p parse:s];
    //NSLog(@"result %@", result);
    
    STAssertNotNil(result, @"");

    id d = result;
    STAssertNotNil(d, @"");
    STAssertTrue([d isKindOfClass:[NSDictionary class]], @"");
    
    NSArray *products = [d objectForKey:@"products"];
    STAssertNotNil(products, @"");
    STAssertTrue([products isKindOfClass:[NSArray class]], @"");
}


- (void)testYahoo4 {
    s = @"["
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,"
        @"1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
        @"]";

    p = [[[TDFastJsonParser alloc] init] autorelease];
    result = [p parse:s];
    //NSLog(@"result %@", result);
    
    STAssertNotNil(result, @"");

    id d = result;
    STAssertNotNil(d, @"");
    STAssertTrue([d isKindOfClass:[NSArray class]], @"");
    
//    NSArray *products = [d objectForKey:@"products"];
//    STAssertNotNil(products, @"");
//    STAssertTrue([products isKindOfClass:[NSArray class]], @"");
}
@end
