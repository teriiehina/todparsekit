//
//  TDJSDelimitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSDelimitState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <ParseKit/TDDelimitState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDDelimitState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDDelimitState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDDelimitState]", ex);
}

static JSValueRef TDDelimitState_add(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDDelimitState_class, "add");
    TDPreconditionMethodArgc(4, "TDDelimitState.add");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    NSString *end = TDJSValueGetNSString(ctx, argv[1], ex);
    NSString *chars = TDJSValueGetNSString(ctx, argv[2], ex);
    BOOL invert = JSValueToBoolean(ctx, argv[3]);
    
    TDDelimitState *data = JSObjectGetPrivate(this);
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:chars];
    if (invert) {
        cs = [cs invertedSet];
    }
    [data addStartMarker:start endMarker:end allowedCharacterSet:cs];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDDelimitState_remove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDDelimitState_class, "remove");
    TDPreconditionMethodArgc(1, "TDDelimitState.remove");
    
    NSString *start = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDDelimitState *data = JSObjectGetPrivate(this);
    [data removeStartMarker:start];
    
    return JSValueMakeUndefined(ctx);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDDelimitState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDDelimitState_finalize(JSObjectRef this) {
    // released in TDTokenizerState_finalize
}

static JSStaticFunction TDDelimitState_staticFunctions[] = {
{ "toString", TDDelimitState_toString, kJSPropertyAttributeDontDelete },
{ "add", TDDelimitState_add, kJSPropertyAttributeDontDelete },
{ "remove", TDDelimitState_remove, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDDelimitState_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDDelimitState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDDelimitState_staticFunctions;
        def.staticValues = TDDelimitState_staticValues;
        def.initialize = TDDelimitState_initialize;
        def.finalize = TDDelimitState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDDelimitState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDDelimitState_class(ctx), data);
}

JSObjectRef TDDelimitState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDDelimitState *data = [[TDDelimitState alloc] init];
    return TDDelimitState_new(ctx, data);
}
