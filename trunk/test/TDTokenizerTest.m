//
//  TDTokenizerTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenizerTest.h"
#import "TDParseKit.h"

@implementation TDTokenizerTest

@synthesize tokenizer;
@synthesize string;

- (void)setUp {
//    self.string = @"oh hai";
//    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
}


- (void)tearDown {
    self.tokenizer = nil;
    self.string = nil;
}

#pragma mark -

- (void)testBlastOff {
    NSString *s = @"\"It's 123 blast-off!\", she said, // watch out!\n"
                    @"and <= 3 'ticks' later /* wince */, it's blast-off!";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    
    //NSLog(@"\n\n starting!!! \n\n");
    while ((tok = [t nextToken]) != eof) {
        //NSLog(@"(%@)", tok.stringValue);
    }
    //NSLog(@"\n\n done!!! \n\n");
    
}

- (void)testStuff {
    NSString *s = @"2 != 47. Blast-off!! 'Woo-hoo!'";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    
    while ((tok = [t nextToken]) != eof) {
        //NSLog(@"(%@) (%.1f) : %@", tok.stringValue, tok.floatValue, [tok debugDescription]);
    }
}


- (void)testStuff2 {
    NSString *s = @"2 != 47. Blast-off!! 'Woo-hoo!'";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isNumber, @"");
    STAssertEqualObjects(tok.stringValue, @"2", @"");
    STAssertEqualObjects(tok.value, [NSNumber numberWithFloat:2.0], @"");

    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @"!=", @"");
    STAssertEqualObjects(tok.value, @"!=", @"");

    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isNumber, @"");
    STAssertEqualObjects(tok.stringValue, @"47", @"");
    STAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0], @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @".", @"");
    STAssertEqualObjects(tok.value, @".", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isWord, @"");
    STAssertEqualObjects(tok.stringValue, @"Blast-off", @"");
    STAssertEqualObjects(tok.value, @"Blast-off", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @"!", @"");
    STAssertEqualObjects(tok.value, @"!", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @"!", @"");
    STAssertEqualObjects(tok.value, @"!", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isQuotedString, @"");
    STAssertEqualObjects(tok.stringValue, @"'Woo-hoo!'", @"");
    STAssertEqualObjects(tok.value, @"'Woo-hoo!'", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok == eof, @"");
}


- (void)testFortySevenDot {
    NSString *s = @"47.";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isNumber, @"");
    STAssertEqualObjects(tok.stringValue, @"47", @"");
    STAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0], @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @".", @"");
    STAssertEqualObjects(tok.value, @".", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok == eof, @"");
}


- (void)testFortySevenDotSpaceFoo {
    NSString *s = @"47. foo";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isNumber, @"");
    STAssertEqualObjects(tok.stringValue, @"47", @"");
    STAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0], @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isSymbol, @"");
    STAssertEqualObjects(tok.stringValue, @".", @"");
    STAssertEqualObjects(tok.value, @".", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok != eof, @"");
    STAssertTrue(tok.isWord, @"");
    STAssertEqualObjects(tok.stringValue, @"foo", @"");
    STAssertEqualObjects(tok.value, @"foo", @"");
    
    tok = [t nextToken];
    STAssertNotNil(tok, @"");
    STAssertTrue(tok == eof, @"");
}


- (void)testDotOne {
    self.string = @"   .999";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEquals(0.999f, t.floatValue, @"");
    STAssertTrue(t.isNumber, @"");    

//    if ([TDToken EOFToken] == token) break;
    
}


- (void)testSpaceDotSpace {
    self.string = @" . ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEqualObjects(@".", t.stringValue, @"");
    STAssertTrue(t.isSymbol, @"");    
    
    //    if ([TDToken EOFToken] == token) break;
    
}


- (void)testInitSig {
    self.string = @"- (id)init {";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEqualObjects(@"-", t.stringValue, @"");    
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertTrue(t.isSymbol, @"");    
}


- (void)testMinusSpaceTwo {
    self.string = @"- 2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEqualObjects(@"-", t.stringValue, @"");    
    STAssertEquals(0.0f, t.floatValue, @"");    
    STAssertTrue(t.isSymbol, @"");    
    
    t = [tokenizer nextToken];
    STAssertEqualObjects(@"2", t.stringValue, @"");    
    STAssertEquals(2.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");    
}


- (void)testMinusPlusTwo {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEqualObjects(@"+", t.stringValue, @"");    
    STAssertTrue(t.isSymbol, @"");

    t = [tokenizer nextToken];
    STAssertEquals(2.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");
    STAssertEqualObjects(@"2", t.stringValue, @"");    

    STAssertEquals([TDToken EOFToken], [tokenizer nextToken], @"");
}


- (void)testMinusPlusTwoCustom {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    [tokenizer setTokenizerState:tokenizer.numberState from:'+' to:'+'];
    
    TDToken *t = [tokenizer nextToken];
    STAssertEquals(2.0f, t.floatValue, @"");    
    STAssertTrue(t.isNumber, @"");
    STAssertEqualObjects(@"+2", t.stringValue, @"");    
    
    STAssertEquals([TDToken EOFToken], [tokenizer nextToken], @"");
}


- (void)testSimpleAPIUsage {
    self.string = @".    ,    ()  12.33333 .:= .456\n\n>=<     'boooo'fasa  this should /*     not*/ appear \r /*but  */this should >=<//n't";

    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    [tokenizer.symbolState add:@":="];
    [tokenizer.symbolState add:@">=<"];
    
    NSMutableArray *toks = [NSMutableArray array];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *token = nil;
    while (token = [tokenizer nextToken]) {
        if (eof == token) break;
        
        [toks addObject:token];

    }

    //NSLog(@"\n\n\n\ntoks: %@\n\n\n\n", toks);
}


- (void)testKatakana1 {
    self.string = @"ア";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    STAssertNotNil(tok, @"");
    STAssertTrue(tok.isWord, @"");
    STAssertEqualObjects(string, tok.stringValue, @"");
    
    tok = [tokenizer nextToken];
    STAssertEqualObjects(eof, tok, @"");
}


- (void)testKatakana2 {
    self.string = @"アア";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    STAssertNotNil(tok, @"");
    STAssertTrue(tok.isWord, @"");
    STAssertEqualObjects(string, tok.stringValue, @"");
    
    tok = [tokenizer nextToken];
    STAssertEqualObjects(eof, tok, @"");
}


- (void)testKatakana3 {
    self.string = @"アェ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    STAssertNotNil(tok, @"");
    STAssertTrue(tok.isWord, @"");
    STAssertEqualObjects(string, tok.stringValue, @"");
    
    tok = [tokenizer nextToken];
    STAssertEqualObjects(eof, tok, @"");
}

@end
