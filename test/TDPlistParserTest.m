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
    parser = [[TDPlistParser alloc] init];
}


- (void)tearDown {
    [parser release];
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
- (void)testFoo {
    
}

@end
