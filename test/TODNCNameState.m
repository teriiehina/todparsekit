//
//  TODNCNameState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODNCNameState.h"
#import "TODTokenizer.h"
#import "TODReader.h"
#import "TODXmlToken.h"

@interface TODNCNameState ()
+ (BOOL)isLetter:(NSInteger)c;
+ (BOOL)isDigit:(NSInteger)c;
+ (BOOL)isNameChar:(NSInteger)c;
+ (BOOL)isValidStartSymbolChar:(NSInteger)c;
+ (BOOL)isValidNonStartSymbolChar:(NSInteger)c;
@end

// NCName	   ::=   	(Letter | '_') (NameChar)*
@implementation TODNCNameState

+ (BOOL)isLetter:(NSInteger)c {
	return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z');
}


+ (BOOL)isDigit:(NSInteger)c {
	return ('0' <= c && c <= '9');
}


//- (BOOL)isWhitespace:(NSInteger)c {
//	return (' ' == c || '\n' == c || '\r' == c || '\t' == c);
//}


//	NameChar	   ::=   	 Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender
+ (BOOL)isNameChar:(NSInteger)c {
	if ([[self class] isLetter:c]) {
		return YES;
	} else if ([[self class] isDigit:c]) {
		return YES;
	} else if ([[self class] isValidNonStartSymbolChar:c]) {
		return YES;
	}
	// TODO CombiningChar & Extender
	return NO;
}


+ (BOOL)isValidStartSymbolChar:(NSInteger)c {
	return ('_' == c);
}


+ (BOOL)isValidNonStartSymbolChar:(NSInteger)c {
	return ('_' == c || '.' == c || '-' == c);
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
	} else {
//		return [[[TODXmlToken alloc] initWithTokenType:TODTT_NAME 
//										   stringValue:[[stringbuf copy] autorelease] 
//											floatValue:0.0f] autorelease];
		return nil;
	}
}

@end
