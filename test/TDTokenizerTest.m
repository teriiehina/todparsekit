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
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isNumber);
    TDAssertEqualObjects(tok.stringValue, @"2");
    TDAssertEqualObjects(tok.value, [NSNumber numberWithFloat:2.0]);

    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @"!=");
    TDAssertEqualObjects(tok.value, @"!=");

    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isNumber);
    TDAssertEqualObjects(tok.stringValue, @"47");
    TDAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @".");
    TDAssertEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isWord);
    TDAssertEqualObjects(tok.stringValue, @"Blast-off");
    TDAssertEqualObjects(tok.value, @"Blast-off");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @"!");
    TDAssertEqualObjects(tok.value, @"!");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @"!");
    TDAssertEqualObjects(tok.value, @"!");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isQuotedString);
    TDAssertEqualObjects(tok.stringValue, @"'Woo-hoo!'");
    TDAssertEqualObjects(tok.value, @"'Woo-hoo!'");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok == eof);
}


- (void)testFortySevenDot {
    NSString *s = @"47.";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isNumber);
    TDAssertEqualObjects(tok.stringValue, @"47");
    TDAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @".");
    TDAssertEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok == eof);
}


- (void)testFortySevenDotSpaceFoo {
    NSString *s = @"47. foo";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isNumber);
    TDAssertEqualObjects(tok.stringValue, @"47");
    TDAssertEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isSymbol);
    TDAssertEqualObjects(tok.stringValue, @".");
    TDAssertEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok != eof);
    TDAssertTrue(tok.isWord);
    TDAssertEqualObjects(tok.stringValue, @"foo");
    TDAssertEqualObjects(tok.value, @"foo");
    
    tok = [t nextToken];
    TDAssertNotNil(tok);
    TDAssertTrue(tok == eof);
}


- (void)testDotOne {
    self.string = @"   .999";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEquals(0.999f, t.floatValue);
    TDAssertTrue(t.isNumber);    

//    if ([TDToken EOFToken] == token) break;
    
}


- (void)testSpaceDotSpace {
    self.string = @" . ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEqualObjects(@".", t.stringValue);
    TDAssertTrue(t.isSymbol);    
    
    //    if ([TDToken EOFToken] == token) break;
    
}


- (void)testInitSig {
    self.string = @"- (id)init {";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEqualObjects(@"-", t.stringValue);    
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertTrue(t.isSymbol);    
}


- (void)testMinusSpaceTwo {
    self.string = @"- 2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEqualObjects(@"-", t.stringValue);    
    TDAssertEquals(0.0f, t.floatValue);    
    TDAssertTrue(t.isSymbol);    
    
    t = [tokenizer nextToken];
    TDAssertEqualObjects(@"2", t.stringValue);    
    TDAssertEquals(2.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);    
}


- (void)testMinusPlusTwo {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEqualObjects(@"+", t.stringValue);    
    TDAssertTrue(t.isSymbol);

    t = [tokenizer nextToken];
    TDAssertEquals(2.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);
    TDAssertEqualObjects(@"2", t.stringValue);    

    TDAssertEquals([TDToken EOFToken], [tokenizer nextToken]);
}


- (void)testMinusPlusTwoCustom {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    [tokenizer setTokenizerState:tokenizer.numberState from:'+' to:'+'];
    
    TDToken *t = [tokenizer nextToken];
    TDAssertEquals(2.0f, t.floatValue);    
    TDAssertTrue(t.isNumber);
    TDAssertEqualObjects(@"+2", t.stringValue);    
    
    TDAssertEquals([TDToken EOFToken], [tokenizer nextToken]);
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
    
    TDAssertNotNil(tok);
    TDAssertTrue(tok.isWord);
    TDAssertEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDAssertEqualObjects(eof, tok);
}


- (void)testKatakana2 {
    self.string = @"アア";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    TDAssertNotNil(tok);
    TDAssertTrue(tok.isWord);
    TDAssertEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDAssertEqualObjects(eof, tok);
}


- (void)testKatakana3 {
    self.string = @"アェ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    TDAssertNotNil(tok);
    TDAssertTrue(tok.isWord);
    TDAssertEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDAssertEqualObjects(eof, tok);
}

@end
