//
//  TDJSEmpty.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSEmpty.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKEmpty.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDEmpty_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDEmpty_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDEmpty_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDEmpty_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDEmpty_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDEmpty_staticFunctions;
        def.staticValues = TDEmpty_staticValues;
        def.initialize = TDEmpty_initialize;
        def.finalize = TDEmpty_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDEmpty_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDEmpty_class(ctx), data);
}

JSObjectRef TDEmpty_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    PKEmpty *data = [[PKEmpty alloc] init];
    return TDEmpty_new(ctx, data);
}
