//
//  TODWordState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import "TODWordState.h"
#import "TODReader.h"
#import "TODTokenizer.h"
#import "TODToken.h"

@interface TODWordState () 
- (BOOL)isWordChar:(NSInteger)c;

@property (nonatomic, retain) NSMutableArray *wordChars;
@property (nonatomic, retain) NSNumber *yesFlag;
@property (nonatomic, retain) NSNumber *noFlag;
@end

@implementation TODWordState

- (id)init {
	self = [super init];
	if (self != nil) {
		self.yesFlag = [NSNumber numberWithBool:YES];
		self.noFlag = [NSNumber numberWithBool:NO];

		self.wordChars = [NSMutableArray array];
		NSInteger i = 0;
		for ( ; i < 256; i++) {
			[wordChars addObject:noFlag];
		}
		
		[self setWordChars:YES from: 'a' to: 'z'];
		[self setWordChars:YES from: 'A' to: 'Z'];
		[self setWordChars:YES from: '0' to: '9'];
		[self setWordChars:YES from: '-' to: '-'];
		[self setWordChars:YES from: '_' to: '_'];
		[self setWordChars:YES from:'\'' to:'\''];
		[self setWordChars:YES from:0xc0 to:0xff];
	}
	return self;
}


- (void)dealloc {
	self.wordChars = nil;
	[super dealloc];
}


- (void)setWordChars:(BOOL)yn from:(NSInteger)start to:(NSInteger)end {
	if (start >= 256 || end >= 256) {
		[NSException raise:@"TODWordStateNotSupportedException" format:@"TODWordState only supports setting word chars for chars in the latin-1 set (under 256)"];
	}
	
	id obj = yn ? yesFlag : noFlag;
	NSInteger i = 0;
	for (i = start; i <= end; i++) {
		[wordChars replaceObjectAtIndex:i withObject:obj];
	}
}


- (BOOL)isWordChar:(NSInteger)c {
	BOOL explicitlySet = NO;
	
	if (c > -1 && c < wordChars.count -1) {
		explicitlySet = (yesFlag == [wordChars objectAtIndex:c]);
	}

	if (explicitlySet) {
		return YES;
	}
	
	if (c < 256) {
		return NO;
	} else if (c >= 0x2000 && c <= 0x2bff) { // various symbols
		return NO;
	} else if (c >= 0xfe30 && c <= 0xfe6f) { // general punctuation
		return NO;
	} else if (c >= 0xfe30 && c <= 0xfe6f) { // western musical symbols
		return NO;
	} else if (c >= 0xff00 && c <= 0xff65) { // symbols within Hiragana & Katakana
		return NO;			
	} else if (c >= 0xfff0 && c <= 0xffff) { // specials
		return NO;			
	} else if (c < 0) {
		return NO;
	} else {
		return YES;
	}
}


// charbuf impl 
//- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
//	//	'a' to: 'z'
//	//	'A' to: 'Z'
//	//	0xc0 to:0xff
//	
//	//[self reset];
//
//	NSInteger i = 0;
//	NSInteger c = cin;
//	do {
//		[self checkBufLength:i];
//		charbuf[i++] = c;
//		c = [r read];
//	} while ([self isWordChar:c]);
//	
//	if (c != -1) {
//		[r unread];
//	}
//	
//	NSString *stringValue = [[[NSString alloc] initWithBytes:charbuf length:i encoding:NSISOLatin1StringEncoding] autorelease];
////	NSString *stringValue = [NSString stringWithCString:charbuf length:i];
//	//NSString *stringValue = [[[NSString alloc] initWithCStringNoCopy:charbuf length:i freeWhenDone:YES] autorelease];
//	
//	return [[[TODToken alloc] initWithTokenType:TODTT_WORD 
//										   stringValue:stringValue
//										   floatValue:0.0f] autorelease];
//}


- (TODToken *)nextTokenFromReader:(TODReader *)r startingWith:(NSInteger)cin tokenizer:(TODTokenizer *)t {
	[self reset];
	
	NSInteger c = cin;
	do {
		[stringbuf appendFormat:@"%C", c];
		c = [r read];
	} while ([self isWordChar:c]);
	
	if (c != -1) {
		[r unread];
	}
	
	return [[[TODToken alloc] initWithTokenType:TODTT_WORD 
									stringValue:[[stringbuf copy] autorelease] 
									 floatValue:0.0f] autorelease];
}


@synthesize wordChars;
@synthesize yesFlag;
@synthesize noFlag;
@end
