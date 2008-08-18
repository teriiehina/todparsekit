//
//  TODLowercaseWordTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODLowercaseWordTest.h"
#import "TODParseKit.h"

@implementation TODLowercaseWordTest

- (void)testFoobar {
	NSString *s = @"Foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODLowercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}


- (void)testfoobar {
	NSString *s = @"foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODLowercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[foobar]foobar^", [result description], @"");
}


- (void)test123 {
	NSString *s = @"123";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODLowercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}


- (void)testPercentFoobar {
	NSString *s = @"%Foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODLowercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}

@end
