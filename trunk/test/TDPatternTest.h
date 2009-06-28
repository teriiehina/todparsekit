//
//  TDPatternTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/31/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDPatternTest : SenTestCase {
    TDTokenizer *t;
    TDPattern *p;
    TDUnion *inc;
    TDAssembly *a;
    NSString *s;
}

@end
