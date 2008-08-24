//
//  TDQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDQuoteState.h>
#import <TDParseKit/TDReader.h>
#import <TDParseKit/TDToken.h>

@implementation TDQuoteState


- (void)dealloc {
	[super dealloc];
}


// charbuf impl
//- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
//	
//	NSInteger i = 0;
//	charbuf[i++] = cin;
//	NSInteger c;
//	do {
//		c = [r read];
//		if (c < 0) {
//			c = cin;
//		}
//
//		[self checkBufLength:i];
//		charbuf[i++] = c;
//	} while (c != cin);
//	
//	//NSString *stringValue = [NSString stringWithCString:charbuf length:i];
//	//NSString *stringValue = [[[NSString alloc] initWithBytesNoCopy:charbuf length:i encoding:NSISOLatin1StringEncoding freeWhenDone:YES] autorelease];
//	NSString *stringValue = [[[NSString alloc] initWithBytes:charbuf length:i encoding:NSISOLatin1StringEncoding] autorelease];
//
//	return [[[TDToken alloc] initWithTokenType:TDTT_QUOTED 
//										   stringValue:stringValue
//										   floatValue:0.0f] autorelease];
//}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
	[self reset];
	
	[stringbuf appendFormat:@"%C", cin];
	NSInteger c;
	do {
		c = [r read];
		if (c < 0) {
			c = cin;
		}
		
		[stringbuf appendFormat:@"%C", c];
	} while (c != cin);
	
	return [[[TDToken alloc] initWithTokenType:TDTT_QUOTED 
									stringValue:stringbuf
									 floatValue:0.0f] autorelease];
}

@end
