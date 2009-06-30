//
//  TDCommentStateTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"

@interface TDCommentStateTest : SenTestCase {
    TDCommentState *commentState;
    PKReader *r;
    TDTokenizer *t;
    NSString *s;
    TDToken *tok;
}

@end
