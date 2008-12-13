//
//  TDReservedWordTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDReservedWordTest.h"
#import "TDParseKit.h"


@implementation TDReservedWordTest

- (void)testFoobar {
    NSString *s = @"Foobar";
    [TDReservedWord setReservedWords:[NSArray arrayWithObject:@"Foobar"]];
    
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDReservedWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[Foobar]Foobar^", [result description]);
//    TDAssertNil(result);
}


- (void)testfoobar {
    NSString *s = @"foobar";
    [TDReservedWord setReservedWords:[NSArray arrayWithObject:@"Foobar"]];
    
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    
    TDParser *p = [TDReservedWord word];
    TDAssembly *result = [p completeMatchFor:a];
    
    TDAssertNil(result);
}

@end
