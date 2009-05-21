//
//  TDDelimitStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDDelimitStateTest.h"

@implementation TDDelimitStateTest

- (void)setUp {
    r = [[TDReader alloc] init];
    t = [[TDTokenizer alloc] init];
    delimitState = t.delimitState;
}


- (void)tearDown {
    [r release];
    [t release];
}


- (void)testLtFooGt {
    s = @"<foo>";
    r.string = s;
    t.string = s;

    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<" endSymbol:@">" allowedCharacterSet:nil];
    
    tok = [t nextToken];

    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooGt {
    s = @"<#foo>";
    r.string = s;
    t.string = s;
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<" endSymbol:@">" allowedCharacterSet:nil];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}

@end
