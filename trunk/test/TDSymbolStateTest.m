//
//  TDSymbolStateTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSymbolStateTest.h"

@implementation TDSymbolStateTest

- (void)setUp {
	symbolState = [[TDSymbolState alloc] init];
}


- (void)tearDown {
	[symbolState release];
	[r release];
}


- (void)testDot {
	s = @".";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testDotA {
	s = @".a";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testDotSpace {
	s = @". ";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testDotDot {
	s = @"..";
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)'.', [r read], @"");
}



- (void)testAddDotDot {
	s = @"..";
	[symbolState add:s];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"..", t.stringValue, @"");
	STAssertEqualObjects(@"..", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testAddDotDotSpace {
	s = @".. ";
	[symbolState add:@".."];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"..", t.stringValue, @"");
	STAssertEqualObjects(@"..", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddColonEqual {
	s = @":=";
	[symbolState add:s];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@":=", t.stringValue, @"");
	STAssertEqualObjects(@":=", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testAddColonEqualSpace {
	s = @":= ";
	[symbolState add:@":="];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@":=", t.stringValue, @"");
	STAssertEqualObjects(@":=", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddGtEqualLtSpace {
	s = @">=< ";
	[symbolState add:@">=<"];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@">=<", t.stringValue, @"");
	STAssertEqualObjects(@">=<", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddGtEqualLt {
	s = @">=<";
	[symbolState add:s];
	r = [[TDReader alloc] initWithString:s];
	TDToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@">=<", t.stringValue, @"");
	//STAssertEqualObjects(@">=<", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testTokenzierAddGtEqualLt {
	s = @">=<";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:s];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}


- (void)testTokenzierAddGtEqualLtSpaceFoo {
	s = @">=< foo";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@">=<"];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");

	tok = [t nextToken];
	STAssertEqualObjects(@"foo", tok.stringValue, @"");
	STAssertEqualObjects(@"foo", tok.value, @"");
	STAssertTrue(tok.isWord, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}


- (void)testTokenzierAddGtEqualLtFoo {
	s = @">=<foo";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@">=<"];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	tok = [t nextToken];
	STAssertEqualObjects(@"foo", tok.stringValue, @"");
	STAssertEqualObjects(@"foo", tok.value, @"");
	STAssertTrue(tok.isWord, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}


- (void)testTokenzierAddGtEqualLtDot {
	s = @">=<.";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@">=<"];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	tok = [t nextToken];
	STAssertEqualObjects(@".", tok.stringValue, @"");
	STAssertEqualObjects(@".", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}


- (void)testTokenzierAddGtEqualLtSpaceDot {
	s = @">=< .";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@">=<"];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	tok = [t nextToken];
	STAssertEqualObjects(@".", tok.stringValue, @"");
	STAssertEqualObjects(@".", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}


- (void)testTokenzierAddGtEqualLtSpaceDotSpace {
	s = @">=< . ";
	TDTokenizer *t = [TDTokenizer tokenizerWithString:s];
	[t.symbolState add:@">=<"];
	TDToken *tok = [t nextToken];
	STAssertEqualObjects(@">=<", tok.stringValue, @"");
	STAssertEqualObjects(@">=<", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	tok = [t nextToken];
	STAssertEqualObjects(@".", tok.stringValue, @"");
	STAssertEqualObjects(@".", tok.value, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	STAssertEquals([TDToken EOFToken], [t nextToken], @"");
}

@end
