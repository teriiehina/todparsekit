//
//  TODReservedWordTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODReservedWordTest.h"
#import "TODParseKit.h"


@implementation TODReservedWordTest

- (void)testFoobar {
	NSString *s = @"Foobar";
	[TODReservedWord setReservedWords:[NSArray arrayWithObject:@"Foobar"]];
	
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODReservedWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[Foobar]Foobar^", [result description], @"");
//	STAssertNil(result, @"");
}


- (void)testfoobar {
	NSString *s = @"foobar";
	[TODReservedWord setReservedWords:[NSArray arrayWithObject:@"Foobar"]];
	
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODReservedWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}

@end
