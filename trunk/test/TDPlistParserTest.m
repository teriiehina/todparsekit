//
//  TDPlistParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDPlistParserTest.h"

@implementation TDPlistParserTest

- (void)setUp {
    p = [[TDPlistParser alloc] init];
}


- (void)tearDown {
    [p release];
}


//    {
//        ArrayKey =     (
//                        one,
//                        two,
//                        three
//                        );
//        FloatKey = 1;
//        IntegerKey = 1;
//        NOKey = 0;
//        StringKey = String;
//        YESKey = 1;
//    }
- (void)testNum1Dot0 {
    s = @"1.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed. 'floatness' has been lost
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"1", [obj stringValue], @"");
    STAssertEquals(1, [obj integerValue], @"");
    STAssertEquals(1.0f, [obj floatValue], @"");
}


- (void)testNum300 {
    s = @"300";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
    // -workOnNumAssembly: has already executed.
    id obj = [res pop]; // NSNumber *
    STAssertTrue([obj isKindOfClass:[NSNumber class]], @"");
    STAssertEqualObjects(@"300", [obj stringValue], @"");
    STAssertEquals(300, [obj integerValue], @"");
    STAssertEquals(300.0f, [obj floatValue], @"");
}

@end
