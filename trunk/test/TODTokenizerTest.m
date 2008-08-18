//
//  TODTokenizerTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/11/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTokenizerTest.h"
#import "TODParseKit.h"

@implementation TODTokenizerTest

@synthesize tokenizer;
@synthesize string;

- (void)setUp {
//	self.string = @"oh hai";
//	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
}


- (void)tearDown {
	self.tokenizer = nil;
	self.string = nil;
}

#pragma mark -

- (void)testBlastOff {
	NSString *s = @"\"It's 123 blast-off!\", she said, // watch out!\n"
					@"and <= 3 'ticks' later /* wince */, it's blast-off!";
	TODTokenizer *t = [TODTokenizer tokenizerWithString:s];
	[t.symbolState add:@"<="];
	
	TODToken *eof = [TODToken EOFToken];
	TODToken *tok = nil;
	
	NSLog(@"\n\n starting!!! \n\n");
	while ((tok = [t nextToken]) != eof) {
		NSLog(@"(%@)", tok.stringValue);
	}
	NSLog(@"\n\n done!!! \n\n");
	
}


- (void)testDotOne {
	self.string = @"   .999";
	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	TODToken *t = [tokenizer nextToken];
	STAssertEquals(0.999f, t.floatValue, @"");
	STAssertTrue(t.isNumber, @"");	

//	if ([TODToken EOFToken] == token) break;
	
}


- (void)testSpaceDotSpace {
	self.string = @" . ";
	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	TODToken *t = [tokenizer nextToken];
	STAssertEqualObjects(@".", t.stringValue, @"");
	STAssertTrue(t.isSymbol, @"");	
	
	//	if ([TODToken EOFToken] == token) break;
	
}


- (void)testInitSig {
	self.string = @"- (id)init {";
	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	TODToken *t = [tokenizer nextToken];
	STAssertEqualObjects(@"-", t.stringValue, @"");	
	STAssertEquals(0.0f, t.floatValue, @"");	
	STAssertTrue(t.isSymbol, @"");	
}


- (void)testMinusSpaceTwo {
	self.string = @"- 2";
	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	TODToken *t = [tokenizer nextToken];
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
	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	TODToken *t = [tokenizer nextToken];
	STAssertEquals(2.0f, t.floatValue, @"");	
	STAssertTrue(t.isNumber, @"");
	STAssertEqualObjects(@"+2", t.stringValue, @"");	

	STAssertEquals([TODToken EOFToken], [tokenizer nextToken], @"");
}


- (void)testSimpleAPIUsage {
	self.string = @".	,	()  12.33333 .:= .456\n\n>=<     'boooo'fasa  this should /*	 not*/ appear \r /*but  */this should >=<//n't";

	self.tokenizer = [[[TODTokenizer alloc] initWithString:string] autorelease];
	
	[tokenizer.symbolState add:@":="];
	[tokenizer.symbolState add:@">=<"];
	
	NSMutableArray *toks = [NSMutableArray array];
	
	TODToken *token = nil;
	while (token = [tokenizer nextToken]) {
		if ([TODToken EOFToken] == token) break;
		
		[toks addObject:token];

	}

	NSLog(@"\n\n\n\ntoks: %@\n\n\n\n", toks);
}

@end
