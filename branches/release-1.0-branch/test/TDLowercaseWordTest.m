//
//  TDLowercaseWordTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDLowercaseWordTest.h"

@implementation TDLowercaseWordTest

- (void)testFoobar {
    NSString *s = @"Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}


- (void)testfoobar {
    NSString *s = @"foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[foobar]foobar^", [result description]);
}


- (void)test123 {
    NSString *s = @"123";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}


- (void)testPercentFoobar {
    NSString *s = @"%Foobar";
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDLowercaseWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}

@end
