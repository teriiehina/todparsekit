//
//  TDUppercaseWordTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDUppercaseWordTest.h"
#import "ParseKit.h"

@implementation TDUppercaseWordTest

- (void)testFoobar {
    NSString *s = @"Foobar";
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    PKParser *p = [TDUppercaseWord word];
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[Foobar]Foobar^", [result description]);
}


- (void)testfoobar {
    NSString *s = @"foobar";
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    PKParser *p = [TDUppercaseWord word];
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}


- (void)test123 {
    NSString *s = @"123";
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    PKParser *p = [TDUppercaseWord word];
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}


- (void)testPercentFoobar {
    NSString *s = @"%Foobar";
    PKAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    PKParser *p = [TDUppercaseWord word];
    PKAssembly *result = [p completeMatchFor:a];
    
    TDNil(result);
}

@end
