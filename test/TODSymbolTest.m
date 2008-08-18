//
//  TODSymbolTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSymbolTest.h"


@implementation TODSymbolTest

- (void)tearDown {
}


- (void)testDash {
	s = @"-";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSymbol symbolWithString:s];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[-]-^", [result description], @"");
}


- (void)testFalseDash {
	s = @"-";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSymbol symbolWithString:@"+"];
	
	TODAssembly *result = [p bestMatchFor:a];
	STAssertNil(result, @"");
}


- (void)testTrueDash {
	s = @"-";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [TODSymbol symbol];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[-]-^", [result description], @"");
}


- (void)testDiscardDash {
	s = @"-";
	a = [TODTokenAssembly assemblyWithString:s];
	
	p = [[TODSymbol symbolWithString:s] discard];
	
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[]-^", [result description], @"");
}
@end
