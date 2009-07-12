//
//  TDTokenizerStateTest.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/12/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenizerStateTest.h"

@implementation TDTokenizerStateTest

- (void)setUp {
    t = [[PKTokenizer alloc] init];
}


- (void)tearDown {
    [t release];
}


- (void)testFallbackStateFromTo {
    [t setTokenizerState:t.symbolState from:'c' to:'c'];
    [t.symbolState setFallbackState:t.wordState from:'c' to:'c'];
    [t.symbolState add:@"cast"];
 
    t.string = @"foo cast cat";
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"cast", tok.stringValue);

    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"cat", tok.stringValue);    

    tok = [t nextToken];
    TDEqualObjects(nil, tok.stringValue);    
    TDTrue([PKToken EOFToken] == tok);
    
}

@end
