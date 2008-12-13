//
//  TDSymbolTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSymbolTest.h"


@implementation TDSymbolTest

- (void)tearDown {
}


- (void)testDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSymbol symbolWithString:s];
    
    TDAssembly *result = [p bestMatchFor:a];
    
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[-]-^", [result description]);
}


- (void)testFalseDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSymbol symbolWithString:@"+"];
    
    TDAssembly *result = [p bestMatchFor:a];
    TDAssertNil(result);
}


- (void)testTrueDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSymbol symbol];
    
    TDAssembly *result = [p bestMatchFor:a];
    
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[-]-^", [result description]);
}


- (void)testDiscardDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [[TDSymbol symbolWithString:s] discard];
    
    TDAssembly *result = [p bestMatchFor:a];
    
    TDAssertNotNil(result);
    TDAssertEqualObjects(@"[]-^", [result description]);
}
@end
