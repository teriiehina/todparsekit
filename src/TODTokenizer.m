//
//  TODParseKit.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODTokenizer.h>
#import <TODParseKit/TODParseKit.h>

@interface TODTokenizer ()
@property (nonatomic, retain) TODReader *reader;

@property (nonatomic, readwrite, retain) TODNumberState *numberState;
@property (nonatomic, readwrite, retain) TODQuoteState *quoteState;
@property (nonatomic, readwrite, retain) TODSlashState *slashState;
@property (nonatomic, readwrite, retain) TODSymbolState *symbolState;
@property (nonatomic, readwrite, retain) TODWhitespaceState *whitespaceState;
@property (nonatomic, readwrite, retain) TODWordState *wordState;

@property (nonatomic, retain) NSMutableArray *tokenizerStates;

- (TODTokenizerState *)tokenizerStateFor:(NSInteger)c;
@end

@implementation TODTokenizer

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
		self.reader = [[[TODReader alloc] init] autorelease];
		
		self.numberState		= [[[TODNumberState alloc] init] autorelease];
		self.quoteState			= [[[TODQuoteState alloc] init] autorelease];
		self.slashState			= [[[TODSlashState alloc] init] autorelease];
		self.symbolState		= [[[TODSymbolState alloc] init] autorelease];
		self.whitespaceState	= [[[TODWhitespaceState alloc] init] autorelease];
		self.wordState			= [[[TODWordState alloc] init] autorelease];

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
		
		[symbolState add:@"<="];
		[symbolState add:@">="];
		[symbolState add:@":="];
		[symbolState add:@"!="];
		[symbolState add:@"=="];
		[symbolState add:@"<>"];
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


- (TODToken *)nextToken {
	NSInteger c = [reader read];
	
	TODToken *result = nil;

	if (-1 == c) {
		result = [TODToken EOFToken];
	} else {
		TODTokenizerState *state = [self tokenizerStateFor:c];
		if (state) {
			result = [state nextTokenFromReader:reader startingWith:c tokenizer:self];
		} else {
			result = [TODToken EOFToken];
		}
	}
	
	return result;
}


- (void)setCharacterState:(TODTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
	NSInteger i = start;
	for ( ; i <= end; i++) {
		[tokenizerStates replaceObjectAtIndex:i withObject:state];
	}
}


- (TODReader *)reader {
	return [[reader retain] autorelease];
}


- (void)setReader:(TODReader *)r {
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

- (TODTokenizerState *)tokenizerStateFor:(NSInteger)c {
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
