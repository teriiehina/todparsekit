//
//  TODXmlNmtokenState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODXmlNmtokenState.h"
#import "TODTokenizer.h"
#import "TODReader.h"
#import "TODXmlToken.h"

@interface TODXmlNameState ()
+ (BOOL)isLetter:(NSInteger)c;
+ (BOOL)isDigit:(NSInteger)c;
+ (BOOL)isNameChar:(NSInteger)c;
+ (BOOL)isValidStartSymbolChar:(NSInteger)c;
@end

// NameChar	   ::=   	 Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar | Extender
@implementation TODXmlNmtokenState

+ (BOOL)isValidStartSymbolChar:(NSInteger)c {
	return ('_' == c || ':' == c || '-' == c || '.' == c);
}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	[self reset];
	
	NSInteger c = cin;
	do {
		[stringbuf appendFormat:@"%C", c];
		c = [r read];
	} while ([[self class] isNameChar:c]);
	
	if (c != -1) {
		[r unread];
	}
	
	if (self.stringbuf.length == 1 && [[self class] isValidStartSymbolChar:cin]) {
		return [t.symbolState nextTokenFromReader:r startingWith:cin tokenizer:t];
	} else if (self.stringbuf.length == 1 && [[self class] isDigit:cin]) {
		return [t.numberState nextTokenFromReader:r startingWith:cin tokenizer:t];
	} else {
		return nil;
//		return [[[TODXmlToken alloc] initWithTokenType:TODTT_NMTOKEN
//										   stringValue:[[stringbuf copy] autorelease] 
//											floatValue:0.0f] autorelease];
	}
}

@end
