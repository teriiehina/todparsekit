//
//  PKJSCommentState.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSCommentState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <ParseKit/PKCommentState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDCommentState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCommentState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDCommentState]", ex);
}

static JSValueRef TDCommentState_addSingleLine(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCommentState_class, "addSingleLine");
    TDPreconditionMethodArgc(1, "PKCommentState.addSingleLine");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDCommentState *data = JSObjectGetPrivate(this);
    [data addSingleLineStartMarker:start];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDCommentState_removeSingleLine(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCommentState_class, "removeSingleLine");
    TDPreconditionMethodArgc(1, "PKCommentState.removeSingleLine");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDCommentState *data = JSObjectGetPrivate(this);
    [data removeSingleLineStartMarker:start];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDCommentState_addMultiLine(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCommentState_class, "addMultiLine");
    TDPreconditionMethodArgc(2, "PKCommentState.addMultiLine");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    NSString *end = TDJSValueGetNSString(ctx, argv[1], ex);
    
    TDCommentState *data = JSObjectGetPrivate(this);
    [data addMultiLineStartMarker:start endMarker:end];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDCommentState_removeMultiLine(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCommentState_class, "removeSingleLine");
    TDPreconditionMethodArgc(1, "PKCommentState.removeMultiLine");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDCommentState *data = JSObjectGetPrivate(this);
    [data removeMultiLineStartMarker:start];
    
    return JSValueMakeUndefined(ctx);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDCommentState_getReportsCommentTokens(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDCommentState *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.reportsCommentTokens);
}

static bool TDCommentState_setReportsCommentTokens(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDCommentState *data = JSObjectGetPrivate(this);
    data.reportsCommentTokens = JSValueToBoolean(ctx, value);
    return true;
}

static JSValueRef TDCommentState_getBalancesEOFTerminatedComments(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDCommentState *data = JSObjectGetPrivate(this);
    return JSValueMakeBoolean(ctx, data.balancesEOFTerminatedComments);
}

static bool TDCommentState_setBalancesEOFTerminatedComments(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDCommentState *data = JSObjectGetPrivate(this);
    data.balancesEOFTerminatedComments = JSValueToBoolean(ctx, value);
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDCommentState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDCommentState_finalize(JSObjectRef this) {
    // released in TDTokenizerState_finalize
}

static JSStaticFunction TDCommentState_staticFunctions[] = {
{ "toString", TDCommentState_toString, kJSPropertyAttributeDontDelete },
{ "addSingleLine", TDCommentState_addSingleLine, kJSPropertyAttributeDontDelete },
{ "removeSingleLine", TDCommentState_removeSingleLine, kJSPropertyAttributeDontDelete },
{ "addMultiLine", TDCommentState_addMultiLine, kJSPropertyAttributeDontDelete },
{ "removeMultiLine", TDCommentState_removeMultiLine, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};


static JSStaticValue TDCommentState_staticValues[] = {        
{ "reportsCommentTokens", TDCommentState_getReportsCommentTokens, TDCommentState_setReportsCommentTokens, kJSPropertyAttributeDontDelete }, // Boolean
{ "balancesEOFTerminatedComments", TDCommentState_getBalancesEOFTerminatedComments, TDCommentState_setBalancesEOFTerminatedComments, kJSPropertyAttributeDontDelete }, // Boolean
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDCommentState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDCommentState_staticFunctions;
        def.staticValues = TDCommentState_staticValues;
        def.initialize = TDCommentState_initialize;
        def.finalize = TDCommentState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDCommentState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDCommentState_class(ctx), data);
}

JSObjectRef TDCommentState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDCommentState *data = [[TDCommentState alloc] init];
    return TDCommentState_new(ctx, data);
}
