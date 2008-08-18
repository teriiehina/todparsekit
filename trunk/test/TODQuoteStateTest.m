//
//  TODQuoteStateTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODQuoteStateTest.h"


@implementation TODQuoteStateTest

- (void)setUp {
	quoteState = [[TODQuoteState alloc] init];
}


- (void)tearDown {
	[quoteState release];
	[r release];
}


- (void)testQuotedString {
	s = @"'stuff'";
	r = [[TODReader alloc] initWithString:s];
	// can't mock reader cuz it has to expect to return primitve values from methods
	// that's not supported by OCMock
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	
}

- (void)testQuotedStringPlus {
	s = @"'a quote here' more";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"'a quote here'", [t stringValue], @"");
}


- (void)test14CharQuotedString {
	s = @"'123456789abcef'";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test15CharQuotedString {
	s = @"'123456789abcefg'";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test16CharQuotedString {
	s = @"'123456789abcefgh'";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test31CharQuotedString {
	s = @"'123456789abcefgh123456789abcefg'";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test32CharQuotedString {
	s = @"'123456789abcefgh123456789abcefgh'";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


@end
