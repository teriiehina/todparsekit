//
//  TDJSWordState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSWordState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <TDParseKit/TDWordState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDWordState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWordState_class, "toString");
    return TDNSStringToJSValue(ctx, @"[object TDWordState]", ex);
}

static JSValueRef TDWordState_setWordChars(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWordState_class, "setWordChars");
    TDPreconditionMethodArgc(3, "TDWordState.setWordChars");

    BOOL yn = JSValueToBoolean(ctx, argv[0]);
    NSString *start = TDJSValueGetNSString(ctx, argv[1], ex);
    NSString *end = TDJSValueGetNSString(ctx, argv[2], ex);
    
    TDWordState *data = JSObjectGetPrivate(this);
    [data setWordChars:yn from:[start characterAtIndex:0] to:[end characterAtIndex:0]];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDWordState_isWordChar(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDWordState_class, "isWordChar");
    TDPreconditionMethodArgc(1, "TDWordState.isWordChar");
    
    NSInteger c = (NSInteger)JSValueToNumber(ctx, argv[0], ex);
    
    TDWordState *data = JSObjectGetPrivate(this);
    BOOL yn = [data isWordChar:c];
    
    return JSValueMakeBoolean(ctx, yn);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDWordState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDWordState_finalize(JSObjectRef this) {
    // released in TDTokenizerState_finalize
}

static JSStaticFunction TDWordState_staticFunctions[] = {
{ "toString", TDWordState_toString, kJSPropertyAttributeDontDelete },
{ "setWordChars", TDWordState_setWordChars, kJSPropertyAttributeDontDelete },
{ "isWordChar", TDWordState_isWordChar, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDWordState_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDWordState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDWordState_staticFunctions;
        def.staticValues = TDWordState_staticValues;
        def.initialize = TDWordState_initialize;
        def.finalize = TDWordState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDWordState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDWordState_class(ctx), data);
}

JSObjectRef TDWordState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDWordState *data = [[TDWordState alloc] init];
    return TDWordState_new(ctx, data);
}
