//
//  TDParseKit.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDParseKit.h>

@interface TDTokenizer ()
@property (nonatomic, retain) TDReader *reader;

@property (nonatomic, readwrite, retain) TDNumberState *numberState;
@property (nonatomic, readwrite, retain) TDQuoteState *quoteState;
@property (nonatomic, readwrite, retain) TDSlashState *slashState;
@property (nonatomic, readwrite, retain) TDSymbolState *symbolState;
@property (nonatomic, readwrite, retain) TDWhitespaceState *whitespaceState;
@property (nonatomic, readwrite, retain) TDWordState *wordState;

@property (nonatomic, retain) NSMutableArray *tokenizerStates;

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c;
@end

@implementation TDTokenizer

+ (id)tokenizer {
	return [[self class] tokenizerWithString:nil];
}


+ (id)tokenizerWithString:(NSString *)s {
	return [[[[self class] alloc] initWithString:s] autorelease];
}


- (id)init {
	return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
	self = [super init];
	if (self != nil) {
		self.string = s;
		self.reader = [[[TDReader alloc] init] autorelease];
		
		self.numberState		= [[[TDNumberState alloc] init] autorelease];
		self.quoteState			= [[[TDQuoteState alloc] init] autorelease];
		self.slashState			= [[[TDSlashState alloc] init] autorelease];
		self.symbolState		= [[[TDSymbolState alloc] init] autorelease];
		self.whitespaceState	= [[[TDWhitespaceState alloc] init] autorelease];
		self.wordState			= [[[TDWordState alloc] init] autorelease];

		self.tokenizerStates = [NSMutableArray arrayWithCapacity:256];
		NSInteger i = 0;
		for ( ; i < 256; i++) {
			[tokenizerStates addObject:symbolState];
		}
		
		[self setCharacterState:whitespaceState	from:   0 to: ' ']; // From:  0 to: 32	From:0x00 to:0x20
		[self setCharacterState:wordState		from: 'a' to: 'z']; // From: 97 to:122	From:0x61 to:0x7a
		[self setCharacterState:wordState		from: 'A' to: 'Z']; // From: 65 to: 90	From:0x41 to:0x5a
		[self setCharacterState:wordState		from:0xc0 to:0xff]; // From:192 to:255	From:0xc0 to:0xff
		[self setCharacterState:numberState		from: '0' to: '9']; // From: 48 to: 57	From:0x30 to:0x39
		[self setCharacterState:numberState		from: '-' to: '-']; // From: 45 to: 45	From:0x2d to:0x2d
		[self setCharacterState:numberState		from: '+' to: '+']; // 
		[self setCharacterState:numberState		from: '.' to: '.']; // 
		[self setCharacterState:quoteState		from: '"' to: '"']; // From: 34 to: 34	From:0x22 to:0x22
		[self setCharacterState:quoteState		from:'\'' to:'\'']; // From: 39 to: 39	From:0x27 to:0x27
		[self setCharacterState:slashState		from: '/' to: '/']; // From: 47 to: 47	From:0x2f to:0x2f
	}
	return self;
}


- (void)dealloc {
	self.string = nil;
	self.reader = nil;
	self.tokenizerStates = nil;
	self.numberState = nil;
	self.quoteState = nil;
	self.slashState = nil;
	self.symbolState = nil;
	self.whitespaceState = nil;
	self.wordState = nil;
	[super dealloc];
}


- (TDToken *)nextToken {
	NSInteger c = [reader read];
	
	TDToken *result = nil;

	if (-1 == c) {
		result = [TDToken EOFToken];
	} else {
		TDTokenizerState *state = [self tokenizerStateFor:c];
		if (state) {
			result = [state nextTokenFromReader:reader startingWith:c tokenizer:self];
		} else {
			result = [TDToken EOFToken];
		}
	}
	
	return result;
}


- (void)setCharacterState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
	NSInteger i = start;
	for ( ; i <= end; i++) {
		[tokenizerStates replaceObjectAtIndex:i withObject:state];
	}
}


- (TDReader *)reader {
	return [[reader retain] autorelease];
}


- (void)setReader:(TDReader *)r {
	if (reader != r) {
		[reader autorelease];
		reader = [r retain];
		[reader setString:string];
	}
}


- (NSString *)string {
	return [[string copy] autorelease];
}


- (void)setString:(NSString *)s {
	if (string != s) {
		[string autorelease];
		string = [s copy];
	}
	[reader setString:string];
}


#pragma mark -

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c {
	if (c < 0 || c > tokenizerStates.count - 1) {
		if (c >= 0x2000 && c <= 0x2bff) { // various symbols
			return symbolState;
		} else if (c >= 0xfe30 && c <= 0xfe6f) { // general punctuation
			return symbolState;
		} else if (c >= 0xfe30 && c <= 0xfe6f) { // western musical symbols
			return symbolState;
		} else if (c >= 0xff00 && c <= 0xff65) { // symbols within Hiragana & Katakana
			return symbolState;			
		} else if (c >= 0xfff0 && c <= 0xffff) { // specials
			return symbolState;			
		} else if (c < 0) {
			return symbolState;
		} else {
			return wordState;
		}
	}
	return [tokenizerStates objectAtIndex:c];
}


@synthesize numberState;
@synthesize quoteState;
@synthesize slashState;
@synthesize symbolState;
@synthesize whitespaceState;
@synthesize wordState;
@synthesize string;
@synthesize tokenizerStates;
@end
