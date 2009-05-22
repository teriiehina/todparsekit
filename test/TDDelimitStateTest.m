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
    t = [[TDTokenizer alloc] init];
    delimitState = t.delimitState;
}


- (void)tearDown {
    [t release];
}


- (void)testLtFooGt {
    s = @"<foo>";
    t.string = s;
    NSCharacterSet *cs = nil;

    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];

    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtFooGtWithFOAllowed {
    s = @"<foo>";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"fo"];
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtFooGtWithFAllowed {
    s = @"<foo>";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"f"];
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"<");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @">");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooGt {
    s = @"<#foo>";
    t.string = s;
    NSCharacterSet *cs = nil;
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<#" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooGtWithFOAllowed {
    s = @"<#foo>";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"fo"];
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<#" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooGtWithFAllowed {
    s = @"<#foo>";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"f"];
    
    [t setTokenizerState:delimitState from:'<' to:'<'];
    [delimitState addStartSymbol:@"<#" endSymbol:@">" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"<");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @">");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooHashGt {
    s = @"=#foo#=";
    t.string = s;
    NSCharacterSet *cs = nil;
    
    [t setTokenizerState:delimitState from:'=' to:'='];
    [delimitState addStartSymbol:@"=#" endSymbol:@"#=" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooHashGtWithFOAllowed {
    s = @"=#foo#=";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"fo"];
    
    [t setTokenizerState:delimitState from:'=' to:'='];
    [delimitState addStartSymbol:@"=#" endSymbol:@"#=" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtHashFooHashGtWithFAllowed {
    s = @"=#foo#=";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"f"];
    
    [t setTokenizerState:delimitState from:'=' to:'='];
    [delimitState addStartSymbol:@"=#" endSymbol:@"#=" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"=");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"=");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollar123Dollar {
    s = @"$123$";
    t.string = s;
    NSCharacterSet *cs = nil;
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$" endSymbol:@"$" allowedCharacterSet:cs];
    
    tok = [t nextToken];

    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarDollar {
    s = @"$$123$$";
    t.string = s;
    NSCharacterSet *cs = nil;
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$$" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarHash {
    s = @"$$123$#";
    t.string = s;
    NSCharacterSet *cs = nil;
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarHashDecimalDigitAllowed {
    s = @"$$123$#";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet decimalDigitCharacterSet];
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarHashAlphanumericAllowed {
    s = @"$$123$#";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet alphanumericCharacterSet];
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarHashAlphanumericAndWhitespaceAndNewlineAllowed {
    s = @"$$123 456\t789\n0$#";
    t.string = s;
    NSMutableCharacterSet *cs = [[[NSCharacterSet alphanumericCharacterSet] mutableCopy] autorelease];
    [cs formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [cs formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    
    TDTrue(tok.isDelimitedString);
    TDEqualObjects(tok.stringValue, s);
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


- (void)testLtDollarDollar123DollarHashWhitespaceAllowed {
    s = @"$$123$#";
    t.string = s;
    NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
    
    [t setTokenizerState:delimitState from:'$' to:'$'];
    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"$");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"$");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isNumber);
    TDEqualObjects(tok.stringValue, @"123");
    TDEquals(tok.floatValue, (CGFloat)123.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"$");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"#");
    TDEquals(tok.floatValue, (CGFloat)0.0);
    
    tok = [t nextToken];
    TDEqualObjects(tok, [TDToken EOFToken]);
}


//- (void)testLtDollarDollarDollarHash {
//    s = @"$$$#";
//    t.string = s;
//    NSCharacterSet *cs = nil;
//    
//    [t setTokenizerState:delimitState from:'$' to:'$'];
//    [delimitState addStartSymbol:@"$$" endSymbol:@"$#" allowedCharacterSet:cs];
//    
//    TDTrue(tok.isDelimitedString);
//    TDEqualObjects(tok.stringValue, s);
//    TDEquals(tok.floatValue, (CGFloat)0.0);
//    
//    tok = [t nextToken];
//    TDEqualObjects(tok, [TDToken EOFToken]);
//}

@end
