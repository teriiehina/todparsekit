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
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isNumber);
    TDEqualObjects(tok.stringValue, @"2");
    TDEqualObjects(tok.value, [NSNumber numberWithFloat:2.0]);

    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"!=");
    TDEqualObjects(tok.value, @"!=");

    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isNumber);
    TDEqualObjects(tok.stringValue, @"47");
    TDEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @".");
    TDEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"Blast-off");
    TDEqualObjects(tok.value, @"Blast-off");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"!");
    TDEqualObjects(tok.value, @"!");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @"!");
    TDEqualObjects(tok.value, @"!");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isQuotedString);
    TDEqualObjects(tok.stringValue, @"'Woo-hoo!'");
    TDEqualObjects(tok.value, @"'Woo-hoo!'");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok == eof);
}


- (void)testFortySevenDot {
    NSString *s = @"47.";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isNumber);
    TDEqualObjects(tok.stringValue, @"47");
    TDEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @".");
    TDEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok == eof);
}


- (void)testFortySevenDotSpaceFoo {
    NSString *s = @"47. foo";
    TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = nil;
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isNumber);
    TDEqualObjects(tok.stringValue, @"47");
    TDEqualObjects(tok.value, [NSNumber numberWithFloat:47.0]);
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isSymbol);
    TDEqualObjects(tok.stringValue, @".");
    TDEqualObjects(tok.value, @".");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok != eof);
    TDTrue(tok.isWord);
    TDEqualObjects(tok.stringValue, @"foo");
    TDEqualObjects(tok.value, @"foo");
    
    tok = [t nextToken];
    TDNotNil(tok);
    TDTrue(tok == eof);
}


- (void)testDotOne {
    self.string = @"   .999";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDEquals(0.999f, t.floatValue);
    TDTrue(t.isNumber);    

//    if ([TDToken EOFToken] == token) break;
    
}


- (void)testSpaceDotSpace {
    self.string = @" . ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDEqualObjects(@".", t.stringValue);
    TDTrue(t.isSymbol);    
    
    //    if ([TDToken EOFToken] == token) break;
    
}


- (void)testInitSig {
    self.string = @"- (id)init {";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDEqualObjects(@"-", t.stringValue);    
    TDEquals(0.0f, t.floatValue);    
    TDTrue(t.isSymbol);    
}


- (void)testMinusSpaceTwo {
    self.string = @"- 2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDEqualObjects(@"-", t.stringValue);    
    TDEquals(0.0f, t.floatValue);    
    TDTrue(t.isSymbol);    
    
    t = [tokenizer nextToken];
    TDEqualObjects(@"2", t.stringValue);    
    TDEquals(2.0f, t.floatValue);    
    TDTrue(t.isNumber);    
}


- (void)testMinusPlusTwo {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *t = [tokenizer nextToken];
    TDEqualObjects(@"+", t.stringValue);    
    TDTrue(t.isSymbol);

    t = [tokenizer nextToken];
    TDEquals(2.0f, t.floatValue);    
    TDTrue(t.isNumber);
    TDEqualObjects(@"2", t.stringValue);    

    TDEquals([TDToken EOFToken], [tokenizer nextToken]);
}


- (void)testMinusPlusTwoCustom {
    self.string = @"+2";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    [tokenizer setTokenizerState:tokenizer.numberState from:'+' to:'+'];
    
    TDToken *t = [tokenizer nextToken];
    TDEquals(2.0f, t.floatValue);    
    TDTrue(t.isNumber);
    TDEqualObjects(@"+2", t.stringValue);    
    
    TDEquals([TDToken EOFToken], [tokenizer nextToken]);
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
    
    TDNotNil(tok);
    TDTrue(tok.isWord);
    TDEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDEqualObjects(eof, tok);
}


- (void)testKatakana2 {
    self.string = @"アア";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    TDNotNil(tok);
    TDTrue(tok.isWord);
    TDEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDEqualObjects(eof, tok);
}


- (void)testKatakana3 {
    self.string = @"アェ";
    self.tokenizer = [[[TDTokenizer alloc] initWithString:string] autorelease];
    
    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [tokenizer nextToken];
    
    TDNotNil(tok);
    TDTrue(tok.isWord);
    TDEqualObjects(string, tok.stringValue);
    
    tok = [tokenizer nextToken];
    TDEqualObjects(eof, tok);
}

@end
