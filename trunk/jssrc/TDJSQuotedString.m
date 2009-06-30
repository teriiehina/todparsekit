//
//  PKJSQuotedString.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSQuotedString.h"
#import "PKJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKQuotedString.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDQuotedString_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDQuotedString_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDQuotedString_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDQuotedString_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDQuotedString_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDQuotedString_staticFunctions;
        def.staticValues = TDQuotedString_staticValues;
        def.initialize = TDQuotedString_initialize;
        def.finalize = TDQuotedString_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDQuotedString_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDQuotedString_class(ctx), data);
}

JSObjectRef TDQuotedString_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    PKQuotedString *data = [[PKQuotedString alloc] init];
    return TDQuotedString_new(ctx, data);
}
