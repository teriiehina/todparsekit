//
//  TDDelimitStateTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDDelimitStateTest : SenTestCase {
    TDDelimitState *delimitState;
    TDReader *r;
    TDTokenizer *t;
    NSString *s;
    TDToken *tok;
}

@end
