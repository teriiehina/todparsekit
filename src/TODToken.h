//
//  TODToken.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	TODTT_EOF,
	TODTT_NUMBER,
	TODTT_QUOTED,
	TODTT_SYMBOL,
	TODTT_WORD,
	TODTT_WHITESPACE
} TODTokenType;

@interface TODToken : NSObject {
	CGFloat floatValue;
	NSString *stringValue;
	TODTokenType tokenType;
	
	BOOL number;
	BOOL quotedString;
	BOOL symbol;
	BOOL word;
	BOOL whitespace;
	
	id value;
}
+ (TODToken *)EOFToken;
+ (id)tokenWithTokenType:(TODTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

- (id)initWithFloatValue:(CGFloat)n;
- (id)initWithStringValue:(NSString *)s;

// designated initializer
- (id)initWithTokenType:(TODTokenType)t stringValue:(NSString *)s floatValue:(CGFloat)n;

- (BOOL)isEqualIgnoringCase:(id)obj;

- (NSString *)debugDescription;

@property (nonatomic, readonly, getter=isNumber) BOOL number;
@property (nonatomic, readonly, getter=isQuotedString) BOOL quotedString;
@property (nonatomic, readonly, getter=isSymbol) BOOL symbol;
@property (nonatomic, readonly, getter=isWord) BOOL word;
@property (nonatomic, readonly, getter=isWhitespace) BOOL whitespace;
@property (nonatomic, readonly) CGFloat floatValue;
@property (nonatomic, readonly, copy) NSString *stringValue;
@property (nonatomic, readonly) TODTokenType tokenType;

// TODO make retain?
@property (nonatomic, readonly, copy) id value;
@end
