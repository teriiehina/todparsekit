//
//  TDSignificantWhitespaceStateTest.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <ParseKit/ParseKit.h>

@interface TDSignificantWhitespaceStateTest : SenTestCase {
    TDSignificantWhitespaceState *whitespaceState;
    PKReader *r;
    NSString *s;    
}

@end
