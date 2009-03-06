//
//  TDJSWhitespaceState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSWhitespaceState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <TDParseKit/TDWhitespaceState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDWhitespaceState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWhitespaceState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDWhitespaceState]", ex);
}

static JSValueRef TDWhitespaceState_setWhitespaceChars(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWhitespaceState_class, "setWhitespaceChars");
    TDPreconditionMethodArgc(3, "TDWhitespaceState.setWhitespaceChars");
    
    BOOL yn = JSValueToBoolean(ctx, argv[0]);
    NSString *start = TDJSValueGetNSString(ctx, argv[1], ex);
    NSString *end = TDJSValueGetNSString(ctx, argv[2], ex);
    
    TDWhitespaceState *data = JSObjectGetPrivate(this);
    [data setWhitespaceChars:yn from:[start characterAtIndex:0] to:[end characterAtIndex:0]];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDWhitespaceState_isWhitespaceChar(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWhitespaceState_class, "isWhitespaceChar");
    TDPreconditionMethodArgc(1, "TDWhitespaceState.add");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDWhitespaceState *data = JSObjectGetPrivate(this);
    BOOL yn = [data isWhitespaceChar:[s characterAtIndex:0]];
    
    return JSValueMakeBoolean(ctx, yn);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDWhitespaceState_getReportsWhitespaceTokens(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDWhitespaceState *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.reportsWhitespaceTokens);
}

static bool TDWhitespaceState_setReportsWhitespaceTokens(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDWhitespaceState *data = JSObjectGetPrivate(this);
    data.reportsWhitespaceTokens = JSValueToBoolean(ctx, value);
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDWhitespaceState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDWhitespaceState_finalize(JSObjectRef this) {
    // released in TDTokenizerState_finalize
}

static JSStaticFunction TDWhitespaceState_staticFunctions[] = {
{ "toString", TDWhitespaceState_toString, kJSPropertyAttributeDontDelete },
{ "setWhitespaceChars", TDWhitespaceState_setWhitespaceChars, kJSPropertyAttributeDontDelete },
{ "isWhitespaceChar", TDWhitespaceState_isWhitespaceChar, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDWhitespaceState_staticValues[] = {        
{ "reportsWhitespaceTokens", TDWhitespaceState_getReportsWhitespaceTokens, TDWhitespaceState_setReportsWhitespaceTokens, kJSPropertyAttributeDontDelete }, // Boolean
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDWhitespaceState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDWhitespaceState_staticFunctions;
        def.staticValues = TDWhitespaceState_staticValues;
        def.initialize = TDWhitespaceState_initialize;
        def.finalize = TDWhitespaceState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDWhitespaceState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDWhitespaceState_class(ctx), data);
}

JSObjectRef TDWhitespaceState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDWhitespaceState *data = [[TDWhitespaceState alloc] init];
    return TDWhitespaceState_new(ctx, data);
}
