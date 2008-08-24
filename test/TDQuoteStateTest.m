//
//  TDQuoteStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TDQuoteStateTest.h"


@implementation TDQuoteStateTest

- (void)setUp {
	quoteState = [[TDQuoteState alloc] init];
}


- (void)tearDown {
	[quoteState release];
	[r release];
}


- (void)testQuotedString {
	s = @"'stuff'";
	r = [[TDReader alloc] initWithString:s];
	// can't mock reader cuz it has to expect to return primitve values from methods
	// that's not supported by OCMock
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	
}

- (void)testQuotedStringPlus {
	s = @"'a quote here' more";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"'a quote here'", [t stringValue], @"");
}


- (void)test14CharQuotedString {
	s = @"'123456789abcef'";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test15CharQuotedString {
	s = @"'123456789abcefg'";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test16CharQuotedString {
	s = @"'123456789abcefgh'";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test31CharQuotedString {
	s = @"'123456789abcefgh123456789abcefg'";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


- (void)test32CharQuotedString {
	s = @"'123456789abcefgh123456789abcefgh'";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [quoteState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(s, [t stringValue], @"");
	STAssertTrue(t.isQuotedString, @"");	
}


@end
