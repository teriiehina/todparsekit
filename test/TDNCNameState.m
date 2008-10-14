//
//  TDNCNameState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDNCNameState.h"
#import "TDTokenizer.h"
#import "TDReader.h"
#import "TDXmlToken.h"

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@interface TDNCNameState ()
+ (BOOL)isLetter:(NSInteger)c;
+ (BOOL)isNameChar:(NSInteger)c;
+ (BOOL)isValidStartSymbolChar:(NSInteger)c;
+ (BOOL)isValidNonStartSymbolChar:(NSInteger)c;
@end

// NCName	   ::=   	(Letter | '_') (NameChar)*
@implementation TDNCNameState

+ (BOOL)isLetter:(NSInteger)c {
	return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z');
}


//- (BOOL)isWhitespace:(NSInteger)c {
//	return (' ' == c || '\n' == c || '\r' == c || '\t' == c);
//}


//	NameChar	   ::=   	 Letter | Digit | '.' | '-' | '_' | CombiningChar | Extender
+ (BOOL)isNameChar:(NSInteger)c {
	if ([[self class] isLetter:c]) {
		return YES;
	} else if (isdigit(c)) {
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


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
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
//		return [[[TDXmlToken alloc] initWithTokenType:TDTT_NAME 
//										   stringValue:[[stringbuf copy] autorelease] 
//											floatValue:0.0f] autorelease];
		return nil;
	}
}

@end
