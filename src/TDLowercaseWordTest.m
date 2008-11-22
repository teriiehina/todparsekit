//
//  TDLowercaseWordTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLowercaseWordTest.h"
#import "TDParseKit.h"

@implementation TDLowercaseWordTest

- (void)testFoobar {
    NSString *s = @"Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    STAssertNil(result, @"");
}


- (void)testfoobar {
    NSString *s = @"foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    STAssertNotNil(result, @"");
    STAssertEqualObjects(@"[foobar]foobar^", [result description], @"");
}


- (void)test123 {
    NSString *s = @"123";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    STAssertNil(result, @"");
}


- (void)testPercentFoobar {
    NSString *s = @"%Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    STAssertNil(result, @"");
}

@end
