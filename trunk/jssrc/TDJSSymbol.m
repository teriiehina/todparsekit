//
//  PKJSSymbol.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSSymbol.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKSymbol.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDSymbol_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDSymbol_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDSymbol_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDSymbol_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDSymbol_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDSymbol_staticFunctions;
        def.staticValues = TDSymbol_staticValues;
        def.initialize = TDSymbol_initialize;
        def.finalize = TDSymbol_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDSymbol_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDSymbol_class(ctx), data);
}

JSObjectRef TDSymbol_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    NSString *s = nil;
    
    if (argc > 0) {
        s = TDJSValueGetNSString(ctx, argv[0], ex);
    }
    
    PKSymbol *data = [[PKSymbol alloc] initWithString:s];
    return TDSymbol_new(ctx, data);
}
