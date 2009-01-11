//
//  TDJSTokenizer.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTokenizer.h"
#import "TDJSUtils.h"
#import "TDJSToken.h"
#import "TDJSWordState.h"
#import "TDJSNumberState.h"
#import "TDJSQuoteState.h"
#import "TDJSWhitespaceState.h"
#import "TDJSCommentState.h"
#import "TDJSSymbolState.h"
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTokenizerState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenizer_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenizer_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDTokenizer]", ex);
}

static JSValueRef TDTokenizer_nextToken(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenizer_class, "nextToken");
    TDTokenizer *data = JSObjectGetPrivate(this);

    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [data nextToken];
    
    if (eof == tok) {
        return TDToken_getEOFToken(ctx);
    }
    
    return TDToken_new(ctx, tok);
}

static JSValueRef TDTokenizer_setTokenizerState(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenizer_class, "setTokenizerState");
    TDPreconditionMethodArgc(3, "TDTokenizer.setTokenizerState");
    
    JSObjectRef stateObj = (JSObjectRef)argv[0];
    TDTokenizerState *state = JSObjectGetPrivate(stateObj);
    NSString *from = TDJSValueGetNSString(ctx, argv[1], ex);
    NSString *to = TDJSValueGetNSString(ctx, argv[2], ex);
    
    TDTokenizer *data = JSObjectGetPrivate(this);
    [data setTokenizerState:state from:[from characterAtIndex:0] to:[to characterAtIndex:0]];

    return JSValueMakeUndefined(ctx);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDTokenizer_getString(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, data.string, ex);
}

static bool TDTokenizer_setString(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    data.string = TDJSValueGetNSString(ctx, value, ex);
    return true;
}

static JSValueRef TDTokenizer_getWordState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDWordState_new(ctx, data.wordState);
    return NULL;
}

static bool TDTokenizer_setWordState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDWordState *state = JSObjectGetPrivate(stateObj);
    data.wordState = state;
    return true;
}

static JSValueRef TDTokenizer_getNumberState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDNumberState_new(ctx, data.numberState);
    return NULL;
}

static bool TDTokenizer_setNumberState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDNumberState *state = JSObjectGetPrivate(stateObj);
    data.numberState = state;
    return true;
}

static JSValueRef TDTokenizer_getQuoteState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDQuoteState_new(ctx, data.quoteState);
    return NULL;
}

static bool TDTokenizer_setQuoteState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDQuoteState *state = JSObjectGetPrivate(stateObj);
    data.quoteState = state;
    return true;
}

static JSValueRef TDTokenizer_getSymbolState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDSymbolState_new(ctx, data.symbolState);
    return NULL;
}

static bool TDTokenizer_setSymbolState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDSymbolState *state = JSObjectGetPrivate(stateObj);
    data.symbolState = state;
    return true;
}

static JSValueRef TDTokenizer_getWhitespaceState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDWhitespaceState_new(ctx, data.whitespaceState);
    return NULL;
}

static bool TDTokenizer_setWhitespaceState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDWhitespaceState *state = JSObjectGetPrivate(stateObj);
    data.whitespaceState = state;
    return true;
}

static JSValueRef TDTokenizer_getCommentState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    return TDCommentState_new(ctx, data.commentState);
    return NULL;
}

static bool TDTokenizer_setCommentState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDCommentState *state = JSObjectGetPrivate(stateObj);
    data.commentState = state;
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenizer_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenizer_finalize(JSObjectRef this) {
    TDTokenizer *data = (TDTokenizer *)JSObjectGetPrivate(this);
    [data autorelease];
}

//- (void)setTokenizerState:(TDTokenizerState *)state from:(NSInteger)start to:(NSInteger)end;
static JSStaticFunction TDTokenizer_staticFunctions[] = {
{ "toString", TDTokenizer_toString, kJSPropertyAttributeDontDelete },
{ "setTokenizerState", TDTokenizer_setTokenizerState, kJSPropertyAttributeDontDelete },
{ "nextToken", TDTokenizer_nextToken, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDTokenizer_staticValues[] = {        
{ "string", TDTokenizer_getString, TDTokenizer_setString, kJSPropertyAttributeDontDelete }, // String
{ "numberState", TDTokenizer_getNumberState, TDTokenizer_setNumberState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ "quoteState", TDTokenizer_getQuoteState, TDTokenizer_setQuoteState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ "commentState", TDTokenizer_getCommentState, TDTokenizer_setCommentState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ "symbolState", TDTokenizer_getSymbolState, TDTokenizer_setSymbolState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ "whitespaceState", TDTokenizer_getWhitespaceState, TDTokenizer_setWhitespaceState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ "wordState", TDTokenizer_getWordState, TDTokenizer_setWordState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDTokenizer_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDTokenizer_staticFunctions;
        def.staticValues = TDTokenizer_staticValues;
        def.initialize = TDTokenizer_initialize;
        def.finalize = TDTokenizer_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTokenizer_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTokenizer_class(ctx), data);
}

JSObjectRef TDTokenizer_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "TDTokenizer");
    
    JSValueRef s = argv[0];
    NSString *string = TDJSValueGetNSString(ctx, s, ex);
    
    TDTokenizer *data = [[TDTokenizer alloc] initWithString:string];
    return TDTokenizer_new(ctx, data);
}
