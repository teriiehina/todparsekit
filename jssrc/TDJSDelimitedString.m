//
//  PKJSDelimitedString.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSDelimitedString.h"
#import "PKJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKDelimitedString.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDDelimitedString_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDDelimitedString_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDDelimitedString_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDDelimitedString_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDDelimitedString_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDDelimitedString_staticFunctions;
        def.staticValues = TDDelimitedString_staticValues;
        def.initialize = TDDelimitedString_initialize;
        def.finalize = TDDelimitedString_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDDelimitedString_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDDelimitedString_class(ctx), data);
}

JSObjectRef TDDelimitedString_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "PKDelimitedString");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    PKDelimitedString *data = [[PKDelimitedString alloc] initWithString:s];
    return TDDelimitedString_new(ctx, data);
}
