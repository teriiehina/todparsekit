//
//  TDJSTerminal.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTerminal.h"
#import "TDJSUtils.h"
#import "TDJSParser.h"
#import <ParseKit/TDTerminal.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTerminal_discard(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTerminal_class, "discard");
    
    TDTerminal *data = JSObjectGetPrivate(this);
    [data discard];
    return this;
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTerminal_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTerminal_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDTerminal_staticFunctions[] = {
{ "discard", TDTerminal_discard, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDTerminal_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDTerminal_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDParser_class(ctx);
        def.staticFunctions = TDTerminal_staticFunctions;
        def.staticValues = TDTerminal_staticValues;
        def.initialize = TDTerminal_initialize;
        def.finalize = TDTerminal_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTerminal_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTerminal_class(ctx), data);
}
