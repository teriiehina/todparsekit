//
//  TDReaderTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDReaderTest.h"


@implementation TDReaderTest

- (void)setUp {
	string = @"abcdefghijklmnopqrstuvwxyz";
	[string retain];
	reader = [[TDReader alloc] initWithString:string];
}


- (void)tearDown {
	[string release];
	[reader release];
}


#pragma mark -

- (void)testReadCharsMatch {
	STAssertNotNil(reader, @"");
	NSInteger len = [string length];
	NSInteger c;
	NSInteger i = 0;
	for ( ; i < len; i++) {
		c = [string characterAtIndex:i];
		STAssertEquals(c, [reader read], @"reader didn't return expected chars");
	}
}


- (void)testReadTooFar {
	NSInteger len = [string length];
	NSInteger i = 0;
	for ( ; i < len; i++) {
		[reader read];
	}
	STAssertEquals((NSInteger)-1, [reader read], @"reader should return -1 when read too far");
}


- (void)testUnread {
	[reader read];
	[reader unread];
	NSInteger a = 'a';
	STAssertEquals(a, [reader read], @"read didn't return expected char");

	[reader read];
	[reader read];
	[reader unread];
	NSInteger c = 'c';
	STAssertEquals(c, [reader read], @"read didn't return expected char");
}


- (void)testUnreadTooFar {
	[reader unread];
	NSInteger a = 'a';
	STAssertEquals(a, [reader read], @"read didn't return expected char");

	[reader unread];
	[reader unread];
	[reader unread];
	[reader unread];
	NSInteger a2 = 'a';
	STAssertEquals(a2, [reader read], @"read didn't return expected char");
}

@end
