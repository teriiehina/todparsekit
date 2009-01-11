//
//  TDJSQuoteState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSQuoteState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <TDParseKit/TDQuoteState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDQuoteState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDQuoteState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDQuoteState]", ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDQuoteState_getBalancesEOFTerminatedQuotes(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDQuoteState *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.balancesEOFTerminatedQuotes);
}

static bool TDQuoteState_setBalancesEOFTerminatedQuotes(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDQuoteState *data = JSObjectGetPrivate(this);
    data.balancesEOFTerminatedQuotes = JSValueToBoolean(ctx, value);
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDQuoteState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDQuoteState_finalize(JSObjectRef this) {
    TDQuoteState *data = (TDQuoteState *)JSObjectGetPrivate(this);
    [data autorelease];
}

static JSStaticFunction TDQuoteState_staticFunctions[] = {
{ "toString", TDQuoteState_toString, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDQuoteState_staticValues[] = {
{ "balancesEOFTerminatedQuotes", TDQuoteState_getBalancesEOFTerminatedQuotes, TDQuoteState_setBalancesEOFTerminatedQuotes, kJSPropertyAttributeDontDelete }, // Boolean
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDQuoteState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDQuoteState_staticFunctions;
        def.staticValues = TDQuoteState_staticValues;
        def.initialize = TDQuoteState_initialize;
        def.finalize = TDQuoteState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDQuoteState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDQuoteState_class(ctx), data);
}

JSObjectRef TDQuoteState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDQuoteState *data = [[TDQuoteState alloc] init];
    return TDQuoteState_new(ctx, data);
}
