//
//  TODQuoteState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODQuoteState.h>
#import <TODParseKit/TODReader.h>
#import <TODParseKit/TODToken.h>

@implementation TODQuoteState


- (void)dealloc {
	[super dealloc];
}


// charbuf impl
//- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
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
//	return [[[TODToken alloc] initWithTokenType:TODTT_QUOTED 
//										   stringValue:stringValue
//										   floatValue:0.0f] autorelease];
//}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
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
	
	return [[[TODToken alloc] initWithTokenType:TODTT_QUOTED 
									stringValue:stringbuf
									 floatValue:0.0f] autorelease];
}

@end
