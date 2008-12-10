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
- (void)testNum {
    s = @"1.0";
    a = [TDTokenAssembly assemblyWithString:s];
    res = [p.numParser completeMatchFor:a];
    STAssertNotNil(res, @"");
    
}

@end
