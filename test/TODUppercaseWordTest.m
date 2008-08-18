//
//  TODUppercaseWordTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODUppercaseWordTest.h"
#import "TODParseKit.h"

@implementation TODUppercaseWordTest

- (void)testFoobar {
	NSString *s = @"Foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODUppercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[Foobar]Foobar^", [result description], @"");
}


- (void)testfoobar {
	NSString *s = @"foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODUppercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}


- (void)test123 {
	NSString *s = @"123";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODUppercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}


- (void)testPercentFoobar {
	NSString *s = @"%Foobar";
	TODAssembly *a = [TODTokenAssembly assemblyWithString:s];
	
	TODParser *p = [TODUppercaseWord word];
	TODAssembly *result = [p completeMatchFor:a];
	
	STAssertNil(result, @"");
}

@end
