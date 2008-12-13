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
    TDTokenizer *t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    
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
    TDAssertNil(result);
}


- (void)testNum {
    s = @"456";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    TDAssertNotNil(result);

    TDAssertEqualObjects(@"[456]456^", [result description]);
    id obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects([NSNumber numberWithFloat:456], obj);

    
    s = @"-3.47";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p numberParser] bestMatchFor:a];
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[-3.47]-3.47^", [result description]);
    obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects([NSNumber numberWithFloat:-3.47], obj);
}


- (void)testString {
    s = @"'foobar'";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[foobar]'foobar'^", [result description]);
    id obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects(@"foobar", obj);

    s = @"\"baz boo boo\"";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p stringParser] bestMatchFor:a];
    TDAssertNotNil(result);
    
    TDAssertEqualObjects(@"[baz boo boo]\"baz boo boo\"^", [result description]);
    obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects(@"baz boo boo", obj);
}


- (void)testBoolean {
    s = @"true";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    TDAssertNotNil(result);

    TDAssertEqualObjects(@"[1]true^", [result description]);
    id obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects([NSNumber numberWithBool:YES], obj);

    s = @"false";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p booleanParser] bestMatchFor:a];
    TDAssertNotNil(result);

    TDAssertEqualObjects(@"[0]false^", [result description]);
    obj = [result pop];
    TDAssertNotNil(obj);
    TDAssertEqualObjects([NSNumber numberWithBool:NO], obj);
}


- (void)testArray {
    s = @"[1, 2, 3]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    
    NSLog(@"result: %@", result);
    TDAssertNotNil(result);
    id obj = [result pop];
    TDAssertEquals((int)3, (int)[obj count]);
    TDAssertEqualObjects([NSNumber numberWithInteger:1], [obj objectAtIndex:0]);
    TDAssertEqualObjects([NSNumber numberWithInteger:2], [obj objectAtIndex:1]);
    TDAssertEqualObjects([NSNumber numberWithInteger:3], [obj objectAtIndex:2]);
    TDAssertEqualObjects(@"[][/1/,/2/,/3/]^", [result description]);

    s = @"[true, 'garlic jazz!', .888]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    TDAssertNotNil(result);
    
    //TDAssertEqualObjects(@"[true, 'garlic jazz!', .888]true/'garlic jazz!'/.888^", [result description]);
    obj = [result pop];
    TDAssertEqualObjects([NSNumber numberWithBool:YES], [obj objectAtIndex:0]);
    TDAssertEqualObjects(@"garlic jazz!", [obj objectAtIndex:1]);
    TDAssertEqualObjects([NSNumber numberWithFloat:.888], [obj objectAtIndex:2]);

    s = @"[1, [2, [3, 4]]]";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p arrayParser] bestMatchFor:a];
    TDAssertNotNil(result);
    //NSLog(@"result: %@", [a stack]);
    TDAssertEqualObjects([NSNumber numberWithInteger:1], [obj objectAtIndex:0]);
}


- (void)testObject {
    s = @"{'key': 'value'}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    TDAssertNotNil(result);
    
    id obj = [result pop];
    TDAssertEqualObjects([obj objectForKey:@"key"], @"value");

    s = @"{'foo': false, 'bar': true, \"baz\": -9.457}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    TDAssertNotNil(result);
    
    obj = [result pop];
    TDAssertEqualObjects([obj objectForKey:@"foo"], [NSNumber numberWithBool:NO]);
    TDAssertEqualObjects([obj objectForKey:@"bar"], [NSNumber numberWithBool:YES]);
    TDAssertEqualObjects([obj objectForKey:@"baz"], [NSNumber numberWithFloat:-9.457]);

    s = @"{'baz': {'foo': [1,2]}}";
    a = [TDTokenAssembly assemblyWithString:s];
    result = [[p objectParser] bestMatchFor:a];
    TDAssertNotNil(result);
    
    obj = [result pop];
    NSDictionary *dict = [obj objectForKey:@"baz"];
    TDAssertTrue([dict isKindOfClass:[NSDictionary class]]);
    NSArray *arr = [dict objectForKey:@"foo"];
    TDAssertTrue([arr isKindOfClass:[NSArray class]]);
    TDAssertEqualObjects([NSNumber numberWithInteger:1], [arr objectAtIndex:0]);
    
    //    TDAssertEqualObjects(@"['baz', 'foo', 1, 2]'baz'/'foo'/1/2^", [result description]);
}


- (void)testCrunchBaseJsonParser {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    TDJsonParser *parser = [[[TDJsonParser alloc] init] autorelease];
    id res = [parser parse:s];
    res = res;
    //NSLog(@"res %@", res);
}


- (void)testCrunchBaseJsonParserTokenization {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"yahoo" ofType:@"json"];
    s = [NSString stringWithContentsOfFile:path];
    TDTokenizer *t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    while (eof != (tok = [t nextToken])) {
        //NSLog(@"tok: %@", tok);
    }    
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
    TDAssertNotNil(result);
    id d = result;
    TDAssertNotNil(d);
    TDAssertTrue([d isKindOfClass:[NSDictionary class]]);
    TDAssertEqualObjects([d objectForKey:@"name"], @"Yahoo!");
    TDAssertEqualObjects([d objectForKey:@"permalink"], @"yahoo");
    TDAssertEqualObjects([d objectForKey:@"homepage_url"], @"http://www.yahoo.com");
    TDAssertEqualObjects([d objectForKey:@"blog_url"], @"http://yodel.yahoo.com/");
    TDAssertEqualObjects([d objectForKey:@"blog_feed_url"], @"http://ycorpblog.com/feed/");
    TDAssertEqualObjects([d objectForKey:@"category_code"], @"web");
    TDAssertEqualObjects([d objectForKey:@"number_of_employees"], [NSNumber numberWithInteger:13600]);
    TDAssertEqualObjects([d objectForKey:@"founded_year"], [NSNumber numberWithInteger:1994]);
    TDAssertEqualObjects([d objectForKey:@"founded_month"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"founded_day"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"deadpooled_year"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"deadpooled_month"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"deadpooled_day"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"deadpooled_url"], [NSNull null]);
    TDAssertEqualObjects([d objectForKey:@"tag_list"], @"search, portal, webmail, photos");
    TDAssertEqualObjects([d objectForKey:@"email_address"], @"");
    TDAssertEqualObjects([d objectForKey:@"phone_number"], @"(408) 349-3300");
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

    TDAssertNotNil(result);

    id d = result;
    TDAssertNotNil(d);
    TDAssertTrue([d isKindOfClass:[NSDictionary class]]);
    
    id image = [d objectForKey:@"image"];
    TDAssertNotNil(image);
    TDAssertTrue([image isKindOfClass:[NSDictionary class]]);

    NSArray *sizes = [image objectForKey:@"available_sizes"];
    TDAssertNotNil(sizes);
    TDAssertTrue([sizes isKindOfClass:[NSArray class]]);
    
    TDAssertEquals(3, (int)sizes.count);
    
    NSArray *first = [sizes objectAtIndex:0];
    TDAssertNotNil(first);
    TDAssertTrue([first isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)first.count);
    
    NSArray *firstKey = [first objectAtIndex:0];
    TDAssertNotNil(firstKey);
    TDAssertTrue([firstKey isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)firstKey.count);
    TDAssertEqualObjects([NSNumber numberWithInteger:150], [firstKey objectAtIndex:0]);
    TDAssertEqualObjects([NSNumber numberWithInteger:37], [firstKey objectAtIndex:1]);
    
    NSArray *second = [sizes objectAtIndex:1];
    TDAssertNotNil(second);
    TDAssertTrue([second isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)second.count);
    
    NSArray *secondKey = [second objectAtIndex:0];
    TDAssertNotNil(secondKey);
    TDAssertTrue([secondKey isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)secondKey.count);
    TDAssertEqualObjects([NSNumber numberWithInteger:200], [secondKey objectAtIndex:0]);
    TDAssertEqualObjects([NSNumber numberWithInteger:50], [secondKey objectAtIndex:1]);
    
    NSArray *third = [sizes objectAtIndex:2];
    TDAssertNotNil(third);
    TDAssertTrue([third isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)third.count);
    
    NSArray *thirdKey = [third objectAtIndex:0];
    TDAssertNotNil(thirdKey);
    TDAssertTrue([thirdKey isKindOfClass:[NSArray class]]);
    TDAssertEquals(2, (int)thirdKey.count);
    TDAssertEqualObjects([NSNumber numberWithInteger:200], [thirdKey objectAtIndex:0]);
    TDAssertEqualObjects([NSNumber numberWithInteger:50], [thirdKey objectAtIndex:1]);
    
    
//    TDAssertEqualObjects([d objectForKey:@"name"], @"Yahoo!");
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
    
    TDAssertNotNil(result);

    id d = result;
    TDAssertNotNil(d);
    TDAssertTrue([d isKindOfClass:[NSDictionary class]]);
    
    NSArray *products = [d objectForKey:@"products"];
    TDAssertNotNil(products);
    TDAssertTrue([products isKindOfClass:[NSArray class]]);
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
    
    TDAssertNotNil(result);

    id d = result;
    TDAssertNotNil(d);
    TDAssertTrue([d isKindOfClass:[NSArray class]]);
    
//    NSArray *products = [d objectForKey:@"products"];
//    TDAssertNotNil(products);
//    TDAssertTrue([products isKindOfClass:[NSArray class]]);
}
@end
