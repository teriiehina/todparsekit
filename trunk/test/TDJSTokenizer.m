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
#import <Foundation/Foundation.h>
#import <TDParseKit/TDTokenizer.h>
#import <TDParseKit/TDToken.h>
#import <TDParseKit/TDTokenizerState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenizer_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    return TDNSStringToJSValue(ctx, @"[object TDTokenizer]", ex);
}

static JSValueRef TDTokenizer_nextToken(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);

    TDToken *eof = [TDToken EOFToken];
    TDToken *tok = [data nextToken];
    
    if (eof == tok) {
        return TDToken_EOFToken(ctx, NULL, NULL, 0, NULL, ex);
    }
    
    return TDToken_new(ctx, tok);
}

static JSValueRef TDTokenizer_setTokenizerState(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    if (argc < 3) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizer.setTokenizerState() requires 3 arguments: state, from, to", ex);
        return JSValueMakeUndefined(ctx);
    }
    
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

static JSValueRef TDTokenizer_getNumberState(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
//    TDTokenizer *data = JSObjectGetPrivate(this);
//    return TDNumberState_new(ctx, data.numberState);
    return NULL;
}

static bool TDTokenizer_setNumberState(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDTokenizer *data = JSObjectGetPrivate(this);
    JSObjectRef stateObj = JSValueToObject(ctx, value, ex);
    TDNumberState *state = JSObjectGetPrivate(stateObj);
    data.numberState = state;
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenizer_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenizer_finalize(JSObjectRef this) {
    TDTokenizer *data = (TDTokenizer *)JSObjectGetPrivate(this);
    [data release];
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
//{ "quoteState", TDTokenizer_getQuoteState, TDTokenizer_setQuoteState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
//{ "commentState", TDTokenizer_getCommentState, TDTokenizer_setCommentState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
//{ "symbolState", TDTokenizer_getSymbolState, TDTokenizer_setSymbolState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
//{ "whitespaceState", TDTokenizer_getWhitespaceState, TDTokenizer_setWhitespaceState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
//{ "wordState", TDTokenizer_getWordState, TDTokenizer_setWordState, kJSPropertyAttributeDontDelete }, // TDTokenizerState
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
    if (argc < 1) {
        (*ex) = TDNSStringToJSValue(ctx, @"TDTokenizer constructor requires 1 argument: string", ex);
        return JSValueToObject(ctx, JSValueMakeUndefined(ctx), ex);
    }
    
    JSValueRef s = argv[0];
    NSString *string = TDJSValueGetNSString(ctx, s, ex);
    
    TDTokenizer *data = [[TDTokenizer alloc] initWithString:string];
    return TDTokenizer_new(ctx, data);
}
