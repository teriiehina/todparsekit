//
//  TDJsonParserTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/17/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@class TDJsonParser;

@interface TDJsonParserTest : SenTestCase {
    TDJsonParser *p;
    NSString *s;
    TDAssembly *a;
    TDAssembly *result;
}

@end