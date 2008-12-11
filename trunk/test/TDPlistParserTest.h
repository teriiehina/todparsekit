//
//  TDPlistParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TDPlistParser.h"

@interface TDPlistParserTest : SenTestCase {
    TDPlistParser *p;
    NSString *s;
    TDTokenAssembly *a;
    TDAssembly *res;
}

@end
