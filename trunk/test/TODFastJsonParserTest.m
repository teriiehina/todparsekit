//
//  TODFastJsonParserTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODFastJsonParserTest.h"
#import "TODFastJsonParser.h"

@implementation TODFastJsonParserTest

- (void)testRun {
	NSString *s = @"{\"foo\":\"bar\"}";
	TODFastJsonParser *p = [[[TODFastJsonParser alloc] init] autorelease];
	id result = [p parse:s];
	
	NSLog(@"result");
	STAssertNotNil(result, @"");
}

@end
