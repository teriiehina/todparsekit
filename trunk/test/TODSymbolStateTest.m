//
//  TODSymbolStateTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/12/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSymbolStateTest.h"

@implementation TODSymbolStateTest

- (void)setUp {
	symbolState = [[TODSymbolState alloc] init];
}


- (void)tearDown {
	[symbolState release];
	[r release];
}


- (void)testDot {
	s = @".";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testDotA {
	s = @".a";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)'a', [r read], @"");
}


- (void)testDotSpace {
	s = @". ";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testDotDot {
	s = @"..";
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertEqualObjects(@".", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)'.', [r read], @"");
}



- (void)testAddDotDot {
	s = @"..";
	[symbolState add:s];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"..", t.stringValue, @"");
	STAssertEqualObjects(@"..", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testAddDotDotSpace {
	s = @".. ";
	[symbolState add:@".."];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@"..", t.stringValue, @"");
	STAssertEqualObjects(@"..", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddColonEqual {
	s = @":=";
	[symbolState add:s];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@":=", t.stringValue, @"");
	STAssertEqualObjects(@":=", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}


- (void)testAddColonEqualSpace {
	s = @":= ";
	[symbolState add:@":="];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@":=", t.stringValue, @"");
	STAssertEqualObjects(@":=", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddGtEqualLtSpace {
	s = @">=< ";
	[symbolState add:@">=<"];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@">=<", t.stringValue, @"");
	STAssertEqualObjects(@">=<", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)' ', [r read], @"");
}


- (void)testAddGtEqualLt {
	s = @">=<";
	[symbolState add:s];
	r = [[TODReader alloc] initWithString:s];
	TODToken *t = [symbolState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
	STAssertEqualObjects(@">=<", t.stringValue, @"");
	//STAssertEqualObjects(@">=<", t.value, @"");
	STAssertTrue(t.isSymbol, @"");
	STAssertEquals((NSInteger)-1, [r read], @"");
}

@end
