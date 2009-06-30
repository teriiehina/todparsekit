//
//  PKJSNum.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSNum.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKNum.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDNum_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDNum_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDNum_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDNum_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDNum_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDNum_staticFunctions;
        def.staticValues = TDNum_staticValues;
        def.initialize = TDNum_initialize;
        def.finalize = TDNum_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDNum_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDNum_class(ctx), data);
}

JSObjectRef TDNum_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    PKNum *data = [[PKNum alloc] init];
    return TDNum_new(ctx, data);
}
