//
//  TDHtmlSyntaxHighlighter.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDHtmlSyntaxHighlighter.h"
#import <TDParseKit/TDParseKit.h>

@interface NSArray (TDHtmlSyntaxHighlighterAdditions)
- (NSMutableArray *)reversedMutableArray;
@end

@implementation NSArray (TDHtmlSyntaxHighlighterAdditions)

- (NSMutableArray *)reversedMutableArray {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
	NSEnumerator *e = [self reverseObjectEnumerator];
	id obj = nil;
	while (obj = [e nextObject]) {
		[result addObject:obj];
	}
	return result;
}

@end

@interface TDHtmlSyntaxHighlighter ()
- (void)workOnTag;
- (void)workOnText;
- (void)workOnComment;
- (id)peek;
- (id)pop;
- (NSArray *)objectsAbove:(id)fence;
- (TDToken *)nextNonWhitespaceTokenFrom:(NSEnumerator *)e;
- (void)consumeWhitespaceOnStack;

@property (retain) TDTokenizer *tokenizer;
@property (retain) NSMutableArray *stack;
@property (retain) TDToken *ltToken;
@property (retain) TDToken *gtToken;
@property (retain) TDToken *startCommentToken;
@property (retain) TDToken *endCommentToken;
@end

@implementation TDHtmlSyntaxHighlighter

- (id)init {
	return [self initWithAttributesForDarkBackground:NO];
}


- (id)initWithAttributesForDarkBackground:(BOOL)isDark {
	self = [super init];
	if (self != nil) {
		isDarkBG = isDark;
		
		self.tokenizer = [TDTokenizer tokenizer];
		
		[tokenizer setTokenizerState:tokenizer.symbolState from: '/' to: '/']; // XML doesn't have slash slash or slash star comments
		
		TDSignificantWhitespaceState *whitespaceState = [[TDSignificantWhitespaceState alloc] init];
		tokenizer.whitespaceState = whitespaceState;
		[tokenizer setTokenizerState:whitespaceState from:0 to:' '];
		[whitespaceState release];
		
		[tokenizer.wordState setWordChars:YES from:':' to:':'];
		
		self.ltToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@"<" floatValue:0.0f];
		self.gtToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@">" floatValue:0.0f];
		
		self.startCommentToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@"<!--" floatValue:0.0f];
		self.endCommentToken = [TDToken tokenWithTokenType:TDTT_SYMBOL stringValue:@"-->" floatValue:0.0f];
		
		[tokenizer.symbolState add:startCommentToken.stringValue];
		[tokenizer.symbolState add:endCommentToken.stringValue];
		
		NSFont *monacoFont = [NSFont fontWithName:@"Monaco" size:11.];
		
		NSColor *textColor = nil;
		NSColor *tagColor = nil;
		NSColor *attrNameColor = nil;
		NSColor *attrValueColor = nil;
		NSColor *eqColor = nil;
		NSColor *commentColor = nil;
		
		if (isDarkBG) {
			textColor = [NSColor whiteColor];
			tagColor = [NSColor colorWithDeviceRed:.70 green:.14 blue:.53 alpha:1.];
			attrNameColor = [NSColor colorWithDeviceRed:.33 green:.45 blue:.48 alpha:1.];
			attrValueColor = [NSColor colorWithDeviceRed:.77 green:.18 blue:.20 alpha:1.];
			eqColor = tagColor;
			commentColor = [NSColor colorWithDeviceRed:.24 green:.70 blue:.27 alpha:1.];
		} else {
			textColor = [NSColor blackColor];
			tagColor = [NSColor purpleColor];
			attrNameColor = [NSColor colorWithDeviceRed:0. green:0. blue:.75 alpha:1.];
			attrValueColor = [NSColor colorWithDeviceRed:.75 green:0. blue:0. alpha:1.];
			eqColor = [NSColor darkGrayColor];
			commentColor = [NSColor grayColor];
		}
		
		self.textAttributes			= [NSDictionary dictionaryWithObjectsAndKeys:
									   textColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
		self.tagAttributes			= [NSDictionary dictionaryWithObjectsAndKeys:
									   tagColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
		self.attrNameAttributes		= [NSDictionary dictionaryWithObjectsAndKeys:
									   attrNameColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
		self.attrValueAttributes	= [NSDictionary dictionaryWithObjectsAndKeys:
									   attrValueColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
		self.eqAttributes			= [NSDictionary dictionaryWithObjectsAndKeys:
									   eqColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
		self.commentAttributes		= [NSDictionary dictionaryWithObjectsAndKeys:
									   commentColor, NSForegroundColorAttributeName,
									   monacoFont, NSFontAttributeName,
									   nil];
	}
	return self;
}


- (void)dealloc {
	self.tokenizer = nil;
	self.stack = nil;
	self.ltToken = nil;
	self.gtToken = nil;
	self.startCommentToken = nil;
	self.endCommentToken = nil;
	self.highlightedString = nil;
	self.textAttributes = nil;
	self.tagAttributes = nil;
	self.attrNameAttributes = nil;
	self.attrValueAttributes = nil;
	self.eqAttributes = nil;
	self.commentAttributes = nil;
	[super dealloc];
}


- (NSAttributedString *)attributedStringForString:(NSString *)s {
	self.stack = [NSMutableArray array];
	self.highlightedString = [[[NSMutableAttributedString alloc] init] autorelease];
	
	tokenizer.string = s;
	TDToken *eof = [TDToken EOFToken];
	TDToken *tok = nil;
	BOOL inComment = NO;
	
	while ((tok = [tokenizer nextToken]) != eof) {
		NSString *sval = tok.stringValue;
		
		if (!inComment && tok.isSymbol) {
			if ([ltToken.stringValue isEqualToString:sval]) {
				[self workOnText];
				[stack addObject:tok];
			} else if ([gtToken.stringValue isEqualToString:sval]) {
				[self workOnTag];
			} else if ([startCommentToken.stringValue isEqualToString:sval]) {
				inComment = YES;
				[stack addObject:tok];
			} else {
				[stack addObject:tok];
			}
		} else if (inComment && [endCommentToken.stringValue isEqualToString:sval]) {
			inComment = NO;
			[self workOnComment];
		} else {
			[stack addObject:tok];
		}
	}
	
	NSAttributedString *result = [[highlightedString copy] autorelease];
	self.stack = nil;
	self.highlightedString = nil;
	tokenizer.string = nil;
	return result;
}


- (TDToken *)nextNonWhitespaceTokenFrom:(NSEnumerator *)e {
	TDToken *tok = [e nextObject];
	while (tok.isWhitespace) {
		NSAttributedString *as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:tagAttributes] autorelease];
		[highlightedString appendAttributedString:as];
		tok = [e nextObject];
	}
	return tok;
}


- (void)consumeWhitespaceOnStack {
	TDToken *tok = [self peek];
	while (tok.isWhitespace) {
		tok = [self pop];
		NSAttributedString *as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:tagAttributes] autorelease];
		[highlightedString appendAttributedString:as];
		tok = [self peek];
	}
}


- (void)workOnComment {
	// reverse toks to be in document order
	NSMutableArray *toks = [[self objectsAbove:startCommentToken] reversedMutableArray];
	
	[self consumeWhitespaceOnStack];
	
	NSAttributedString *as = [[[NSAttributedString alloc] initWithString:startCommentToken.stringValue attributes:commentAttributes] autorelease];
	[highlightedString appendAttributedString:as];
	
	NSEnumerator *e = [toks objectEnumerator];
	
	TDToken *tok = nil;
	while (tok = [self nextNonWhitespaceTokenFrom:e]) {
		if ([tok isEqual:endCommentToken]) {
			break;
		} else {
			as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:commentAttributes] autorelease];
			[highlightedString appendAttributedString:as];
		}
	}
	
	as = [[[NSAttributedString alloc] initWithString:endCommentToken.stringValue attributes:commentAttributes] autorelease];
	[highlightedString appendAttributedString:as];
}


- (void)workOnStartTag:(NSEnumerator *)e {
	while (1) {
		// attr name or ns prefix decl "xmlns:foo" or "/" for empty element
		TDToken *tok = [self nextNonWhitespaceTokenFrom:e];
		if (!tok) return;
		
		NSDictionary *attrs = nil;
		if ([tok.stringValue isEqualToString:@"="]) {
			attrs = eqAttributes;
		} else if ([tok.stringValue isEqualToString:@"/"]) {
			attrs = tagAttributes;
		} else if (tok.isQuotedString) {
			attrs = attrValueAttributes;
		} else {
			attrs = attrNameAttributes;
		}
		
		NSAttributedString *as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:attrs] autorelease];
		[highlightedString appendAttributedString:as];
		
		// "="
		tok = [self nextNonWhitespaceTokenFrom:e];
		if (!tok) return;
		
		if ([tok.stringValue isEqualToString:@"="]) {
			attrs = eqAttributes;
		} else if (tok.isQuotedString) {
			attrs = attrValueAttributes;
		} else {
			attrs = tagAttributes;
		}
		
		as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:attrs] autorelease];
		[highlightedString appendAttributedString:as];
		
		// quoted string attr value or ns url value
		tok = [self nextNonWhitespaceTokenFrom:e];
		if (!tok) return;
		
		as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:attrValueAttributes] autorelease];
		[highlightedString appendAttributedString:as];
	}
}


- (void)workOnEndTag:(NSEnumerator *)e {
	// consume tagName
	TDToken *tok = [e nextObject];
	NSAttributedString *as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:tagAttributes] autorelease];
	[highlightedString appendAttributedString:as];
}


- (void)workOnTag {
	// reverse toks to be in document order
	NSMutableArray *toks = [[self objectsAbove:ltToken] reversedMutableArray];
	
	// append "<"
	NSAttributedString *as = [[[NSAttributedString alloc] initWithString:ltToken.stringValue attributes:tagAttributes] autorelease];
	[highlightedString appendAttributedString:as];
	
	NSEnumerator *e = [toks objectEnumerator];
	
	// consume whitespace to tagName or "/" for end tags or "!" for comments
	TDToken *tok = [self nextNonWhitespaceTokenFrom:e];
	
	if (tok) {
		// consume tagName or "/"
		as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:tagAttributes] autorelease];
		[highlightedString appendAttributedString:as];
		
		if ([tok.stringValue isEqualToString:@"/"]) {
			[self workOnEndTag:e];
		} else {
			[self workOnStartTag:e];
		}
	}
	
	// append ">"
	as = [[[NSAttributedString alloc] initWithString:gtToken.stringValue attributes:tagAttributes] autorelease];
	[highlightedString appendAttributedString:as];
}


- (void)workOnText {
	NSArray *a = [self objectsAbove:gtToken];
	NSEnumerator *e = [a reverseObjectEnumerator];
	TDToken *tok = nil;
	while (tok = [e nextObject]) {
		NSAttributedString *as = [[[NSAttributedString alloc] initWithString:tok.stringValue attributes:textAttributes] autorelease];
		[highlightedString appendAttributedString:as];
	}
}


- (NSArray *)objectsAbove:(id)fence {
	NSMutableArray *res = [NSMutableArray array];
	while (1) {
		if (!stack.count) {
			break;
		}
		id obj = [self pop];
		if ([obj isEqual:fence]) {
			break;
		}
		[res addObject:obj];
	}
	return res;
}


- (id)peek {
	id obj = nil;
	if (stack.count) {
		obj = [stack lastObject];
	}
	return obj;
}


- (id)pop {
	id obj = [self peek];
	if (obj) {
		[stack removeLastObject];
	}
	return obj;
}

@synthesize stack;
@synthesize tokenizer;
@synthesize ltToken;
@synthesize gtToken;
@synthesize startCommentToken;
@synthesize endCommentToken;
@synthesize highlightedString;
@synthesize tagAttributes;
@synthesize textAttributes;
@synthesize attrNameAttributes;
@synthesize attrValueAttributes;
@synthesize eqAttributes;
@synthesize commentAttributes;
@end
