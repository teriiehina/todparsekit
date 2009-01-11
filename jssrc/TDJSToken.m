//
//  TDJSToken.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSToken.h"
#import "TDJSUtils.h"
#import <TDParseKit/TDToken.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDToken_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, [data debugDescription], ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDToken_getTokenType(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeNumber(ctx, data.tokenType);
}

static JSValueRef TDToken_getStringValue(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, data.stringValue, ex);
}

static JSValueRef TDToken_getFloatValue(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeNumber(ctx, data.floatValue);
}

static JSValueRef TDToken_getIsNumber(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isNumber);
}

static JSValueRef TDToken_getIsSymbol(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isSymbol);
}

static JSValueRef TDToken_getIsWord(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isWord);
}

static JSValueRef TDToken_getIsQuotedString(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isQuotedString);
}

static JSValueRef TDToken_getIsWhitespace(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isWhitespace);
}

static JSValueRef TDToken_getIsComment(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDToken *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.isComment);
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDToken_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDToken_finalize(JSObjectRef this) {
    TDToken *data = (TDToken *)JSObjectGetPrivate(this);
    [data autorelease];
}

static JSStaticFunction TDToken_staticFunctions[] = {
{ "toString", TDToken_toString, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDToken_staticValues[] = {        
{ "tokenType", TDToken_getTokenType, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Number
{ "stringValue", TDToken_getStringValue, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // String
{ "floatValue", TDToken_getFloatValue, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Number
{ "isNumber", TDToken_getIsNumber, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ "isSymbol", TDToken_getIsSymbol, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ "isWord", TDToken_getIsWord, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ "isQuotedString", TDToken_getIsQuotedString, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ "isWhitespace", TDToken_getIsWhitespace, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ "isComment", TDToken_getIsComment, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Boolean
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark ClassMethods

// JSObjectCallAsFunctionCallback
//JSValueRef TDToken_EOFToken(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
//    static JSValueRef eof = NULL;
//    if (!eof) {
//        eof = TDToken_new(ctx, [TDToken EOFToken]);
//        JSValueProtect(ctx, eof); // is this necessary/appropriate?
//    }
//    return eof;
//}

JSValueRef TDToken_getEOFToken(JSContextRef ctx) {
    static JSObjectRef eof = NULL;
    if (!eof) {
        eof = TDToken_new(ctx, [TDToken EOFToken]);
    }
    return eof;
}

#pragma mark -
#pragma mark Public

JSClassRef TDToken_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDToken_staticFunctions;
        def.staticValues = TDToken_staticValues;
        def.initialize = TDToken_initialize;
        def.finalize = TDToken_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDToken_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDToken_class(ctx), data);
}

JSObjectRef TDToken_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 3) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDToken constructor requires 3 arguments: tokenType, stringValue, numberValue", ex);
        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
    }
    
    CGFloat tokenType = JSValueToNumber(ctx, argv[0], NULL);
    NSString *stringValue = TDJSValueGetNSString(ctx, argv[1], ex);
    CGFloat floatValue = JSValueToNumber(ctx, argv[2], NULL);

    TDToken *data = [[TDToken alloc] initWithTokenType:tokenType stringValue:stringValue floatValue:floatValue];
    return TDToken_new(ctx, data);
}
