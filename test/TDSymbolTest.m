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
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[-]-^", [result description]);
}


- (void)testFalseDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSymbol symbolWithString:@"+"];
    
    PKAssembly *result = [p bestMatchFor:a];
    TDNil(result);
}


- (void)testTrueDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [TDSymbol symbol];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[-]-^", [result description]);
}


- (void)testDiscardDash {
    s = @"-";
    a = [TDTokenAssembly assemblyWithString:s];
    
    p = [[TDSymbol symbolWithString:s] discard];
    
    PKAssembly *result = [p bestMatchFor:a];
    
    TDNotNil(result);
    TDEqualObjects(@"[]-^", [result description]);
}
@end
