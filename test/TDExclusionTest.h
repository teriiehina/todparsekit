//
//  TDMinusTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDExclusionTest : SenTestCase {
    TDTokenizer *t;
    TDParser *p;
    TDParser *minus;
    TDAssembly *a;
    TDAssembly *res;
    NSString *s;    
}

@end
