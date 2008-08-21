//
//  TODXmlToken.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TODTT_XML_NONE = 0,
    TODTT_XML_START_TAG = 1,
    TODTT_XML_ATTRIBUTE = 2,
    TODTT_XML_TEXT = 3,
    TODTT_XML_CDATA = 4,
    TODTT_XML_ENTITY_REF = 5,
    TODTT_XML_ENTITY = 6,
    TODTT_XML_PROCESSING_INSTRUCTION = 7,
    TODTT_XML_COMMENT = 8,
    TODTT_XML_DOCUMENT = 9,
    TODTT_XML_DOCTYPE = 10,
    TODTT_XML_FRAGMENT = 11,
    TODTT_XML_NOTATION = 12,
    TODTT_XML_WHITESPACE = 13,
    TODTT_XML_SIGNIFICANT_WHITESPACE = 14,
	TODTT_XML_END_TAG = 15,
    TODTT_XML_END_ENTITY = 16,
    TODTT_XML_XML_DECL = 17,
    TODTT_XML_EOF = 18
} TODXmlTokenType;

@interface TODXmlToken : NSObject {
	NSString *stringValue;
	TODXmlTokenType tokenType;
	
	BOOL none;
	BOOL startTag;
	BOOL attribute;
	BOOL text;
	BOOL cdata;
	BOOL entityRef;
	BOOL entity;
	BOOL processingInstruction;
	BOOL comment;
	BOOL document;
	BOOL doctype;
	BOOL fragment;
	BOOL notation;
	BOOL whitespace;
	BOOL significantWhitespace;
	BOOL endTag;
	BOOL endEntity;
	BOOL xmlDecl;
	
	id value;
}
+ (TODXmlToken *)EOFToken;
+ (id)tokenWithTokenType:(TODXmlTokenType)t stringValue:(NSString *)s;

// designated initializer
- (id)initWithTokenType:(TODXmlTokenType)t stringValue:(NSString *)s;

- (BOOL)isEqualIgnoringCase:(id)obj;

- (NSString *)debugDescription;

@property (nonatomic, readonly, getter=isNone) BOOL none;
@property (nonatomic, readonly, getter=isStartTag) BOOL startTag;
@property (nonatomic, readonly, getter=isAttribute) BOOL attribute;
@property (nonatomic, readonly, getter=isText) BOOL text;
@property (nonatomic, readonly, getter=isCdata) BOOL cdata;
@property (nonatomic, readonly, getter=isEntityRef) BOOL entityRef;
@property (nonatomic, readonly, getter=isEntity) BOOL entity;
@property (nonatomic, readonly, getter=isProcessingInstruction) BOOL processingInstruction;
@property (nonatomic, readonly, getter=isComment) BOOL comment;
@property (nonatomic, readonly, getter=isDocument) BOOL document;
@property (nonatomic, readonly, getter=isDoctype) BOOL doctype;
@property (nonatomic, readonly, getter=isFragment) BOOL fragment;
@property (nonatomic, readonly, getter=isNotation) BOOL notation;
@property (nonatomic, readonly, getter=isWhitespace) BOOL whitespace;
@property (nonatomic, readonly, getter=isSignificantWhitespace) BOOL significantWhitespace;
@property (nonatomic, readonly, getter=isEndTag) BOOL endTag;
@property (nonatomic, readonly, getter=isEndEntity) BOOL endEntity;
@property (nonatomic, readonly, getter=isXmlDecl) BOOL xmlDecl;
@property (nonatomic, readonly, copy) NSString *stringValue;
@property (nonatomic, readonly) TODXmlTokenType tokenType;
@property (nonatomic, readonly, copy) id value;
@end
