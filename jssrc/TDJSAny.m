//
//  TDJSAny.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSAny.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/TDAny.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDAny_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDAny_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDAny_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDAny_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDAny_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDAny_staticFunctions;
        def.staticValues = TDAny_staticValues;
        def.initialize = TDAny_initialize;
        def.finalize = TDAny_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDAny_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDAny_class(ctx), data);
}

JSObjectRef TDAny_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDAny *data = [[TDAny alloc] init];
    return TDAny_new(ctx, data);
}
