//
//  TDUppercaseWordTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDUppercaseWordTest.h"
#import "TDParseKit.h"

@implementation TDUppercaseWordTest

- (void)testFoobar {
    NSString *s = @"Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDUppercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[Foobar]Foobar^", [result description]);
}


- (void)testfoobar {
    NSString *s = @"foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDUppercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNil(result);
}


- (void)test123 {
    NSString *s = @"123";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDUppercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNil(result);
}


- (void)testPercentFoobar {
    NSString *s = @"%Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDUppercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNil(result);
}

@end
