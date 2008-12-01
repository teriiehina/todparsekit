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
@property (nonatomic, retain) NSMutableArray *tokenizerStates;

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c;
@end

@implementation TDTokenizer

+ (id)tokenizer {
    return [[self class] tokenizerWithString:nil];
}


+ (id)tokenizerWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


- (id)init {
    return [self initWithString:nil];
}


- (id)initWithString:(NSString *)s {
    self = [super init];
    if (self) {
        self.string = s;
        self.reader = [[[TDReader alloc] init] autorelease];
        
        self.numberState        = [[[TDNumberState alloc] init] autorelease];
        self.quoteState         = [[[TDQuoteState alloc] init] autorelease];
        self.slashState         = [[[TDSlashState alloc] init] autorelease];
        self.symbolState        = [[[TDSymbolState alloc] init] autorelease];
        self.whitespaceState    = [[[TDWhitespaceState alloc] init] autorelease];
        self.wordState          = [[[TDWordState alloc] init] autorelease];

        [symbolState add:@"<="];
        [symbolState add:@">="];
        [symbolState add:@"!="];
        [symbolState add:@"=="];
        
        self.tokenizerStates = [NSMutableArray arrayWithCapacity:256];
        NSInteger i = 0;
        for ( ; i < 256; i++) {
            [tokenizerStates addObject:symbolState];
        }
        
        [self setTokenizerState:whitespaceState from:   0 to: ' ']; // From:  0 to: 32    From:0x00 to:0x20
        [self setTokenizerState:wordState       from: 'a' to: 'z']; // From: 97 to:122    From:0x61 to:0x7A
        [self setTokenizerState:wordState       from: 'A' to: 'Z']; // From: 65 to: 90    From:0x41 to:0x5A
        [self setTokenizerState:wordState       from:0xC0 to:0xFF]; // From:192 to:255    From:0xC0 to:0xFF
        [self setTokenizerState:numberState     from: '0' to: '9']; // From: 48 to: 57    From:0x30 to:0x39
        [self setTokenizerState:numberState     from: '-' to: '-']; // From: 45 to: 45    From:0x2D to:0x2D
        [self setTokenizerState:symbolState     from: '+' to: '+']; // 
        [self setTokenizerState:numberState     from: '.' to: '.']; // 
        [self setTokenizerState:quoteState      from: '"' to: '"']; // From: 34 to: 34    From:0x22 to:0x22
        [self setTokenizerState:quoteState      from:'\'' to:'\'']; // From: 39 to: 39    From:0x27 to:0x27
        [self setTokenizerState:slashState      from: '/' to: '/']; // From: 47 to: 47    From:0x2F to:0x2F
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


- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end {
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
        [self willChangeValueForKey:@"reader"];
        [reader autorelease];
        reader = [r retain];
        [self didChangeValueForKey:@"reader"];
        [reader setString:string];
    }
}


- (NSString *)string {
    return [[string retain] autorelease];
}


- (void)setString:(NSString *)s {
    if (string != s) {
        [self willChangeValueForKey:@"string"];
        [string autorelease];
        string = [s copy];
        [self didChangeValueForKey:@"string"];
    }
    reader.string = string;
}


#pragma mark -

- (TDTokenizerState *)tokenizerStateFor:(NSInteger)c {
    if (c < 0 || c > tokenizerStates.count - 1) {
        if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
            return symbolState;
        } else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
            return symbolState;
        } else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
            return symbolState;
        } else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
            return symbolState;
        } else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
            return symbolState;
        } else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
            return symbolState;
        } else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
            return symbolState;
        } else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
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
