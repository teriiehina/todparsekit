//
//  TODXmlNameTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlNameTest.h"
#import "TODXmlNameState.h"
#import "TODXmlNmtokenState.h"
#import "TODXmlToken.h"

@implementation TODXmlNameTest

- (void)test {
	NSString *s = @"_foob?ar _foobar 2baz";
	TODTokenizer *t = [TODTokenizer tokenizerWithString:s];
	
	//Name	   ::=   	(Letter | '_' | ':') (NameChar)*
	TODXmlNameState *nameState = [[[TODXmlNameState alloc] init] autorelease];
	
	[t setCharacterState:nameState from: '_' to: '_'];
	[t setCharacterState:nameState from: ':' to: ':'];
	[t setCharacterState:nameState from: 'a' to: 'z'];
	[t setCharacterState:nameState from: 'A' to: 'Z'];
	[t setCharacterState:nameState from:0xc0 to:0xff];
	
	TODXmlNmtokenState *nmtokenState = [[[TODXmlNmtokenState alloc] init] autorelease];
	[t setCharacterState:nmtokenState from: '0' to: '9'];
	
	TODXmlToken *tok = nil;
	
	// _foob
	tok = (TODXmlToken *)[t nextToken];
	STAssertNotNil(tok, @"");
	STAssertTrue(tok.isName, @"");

	// '?'
	tok = (TODXmlToken *)[t nextToken];
	STAssertNotNil(tok, @"");
	STAssertTrue(tok.isSymbol, @"");
	
	// ar
	tok = (TODXmlToken *)[t nextToken];
	STAssertNotNil(tok, @"");
	STAssertTrue(tok.isName, @"");
	
	// _foobar
	tok = (TODXmlToken *)[t nextToken];
	STAssertNotNil(tok, @"");
	STAssertTrue(tok.isName, @"");
	
	// 2baz
	tok = (TODXmlToken *)[t nextToken];
	STAssertNotNil(tok, @"");
	STAssertTrue(tok.isNmtoken, @"");
	NSLog(@"tok: %@", tok);
	
}

@end
