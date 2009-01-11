//
//  TDJSSymbolState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/9/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSSymbolState.h"
#import "TDJSUtils.h"
#import "TDJSTokenizerState.h"
#import <TDParseKit/TDSymbolState.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDSymbolState_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDSymbolState_class, @"toString", @"TDSymbolState");
    return TDNSStringToJSValue(ctx, @"[object TDSymbolState]", ex);
}

static JSValueRef TDSymbolState_add(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDSymbolState_class, @"add", @"TDSymbolState");
    TDPreconditionMethodArgc(1, @"TDSymbolState.add");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDSymbolState *data = JSObjectGetPrivate(this);
    [data add:s];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDSymbolState_remove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDSymbolState_class, @"remove", @"TDSymbolState");
    TDPreconditionMethodArgc(1, @"TDSymbolState.remove");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDSymbolState *data = JSObjectGetPrivate(this);
    [data remove:s];
    
    return JSValueMakeUndefined(ctx);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDSymbolState_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDSymbolState_finalize(JSObjectRef this) {
    TDSymbolState *data = (TDSymbolState *)JSObjectGetPrivate(this);
    [data autorelease];
}

static JSStaticFunction TDSymbolState_staticFunctions[] = {
{ "toString", TDSymbolState_toString, kJSPropertyAttributeDontDelete },
{ "add", TDSymbolState_add, kJSPropertyAttributeDontDelete },
{ "remove", TDSymbolState_remove, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDSymbolState_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDSymbolState_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTokenizerState_class(ctx);
        def.staticFunctions = TDSymbolState_staticFunctions;
        def.staticValues = TDSymbolState_staticValues;
        def.initialize = TDSymbolState_initialize;
        def.finalize = TDSymbolState_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDSymbolState_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDSymbolState_class(ctx), data);
}

JSObjectRef TDSymbolState_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDSymbolState *data = [[TDSymbolState alloc] init];
    return TDSymbolState_new(ctx, data);
}
