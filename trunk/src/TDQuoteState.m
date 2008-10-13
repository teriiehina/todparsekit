//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDQuoteState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDToken.h>

@interface TDTokenizerState ()
- (void)reset;
@property (nonatomic, retain) NSMutableString *stringbuf;
@end

@implementation TDQuoteState

- (void)dealloc {
	[super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	[self reset];
	
//	NSInteger i = 0;
//	charbuf[i++] = cin;
	[stringbuf appendFormat:@"%C", cin];
	NSInteger c;
	do {
		c = [r read];
		if (c < 0) {
			c = cin;
		}
		
//		[self checkBufLength:i];
//		charbuf[i++] = c;
		[stringbuf appendFormat:@"%C", c];
	} while (c != cin);
	
//	NSString *stringValue = [[[NSString alloc] initWithCharacters:(const unichar *)charbuf length:i] autorelease];
//	NSString *stringValue = [[[NSString alloc] initWithBytes:charbuf length:i encoding:NSUTF8StringEncoding] autorelease];

	return [TDToken tokenWithTokenType:TDTT_QUOTED stringValue:stringbuf floatValue:0.0f];
}

@end
