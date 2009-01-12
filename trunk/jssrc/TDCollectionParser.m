//
//  TDCollectionCollectionParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDCollectionParser.h"
#import "TDJSUtils.h"
#import "TDJSParser.h"
#import <TDParseKit/TDCollectionParser.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDCollectionParser_add(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCollectionParser_class, "add");
    TDPreconditionMethodArgc(1, "add");
    
    TDCollectionParser *data = JSObjectGetPrivate(this);
    
    JSObjectRef arg = (JSObjectRef)argv[0];
    TDParser *p = (TDParser *)JSObjectGetPrivate(arg);
    [data add:p];
    return JSValueMakeUndefined(ctx);
}

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDCollectionParser_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDCollectionParser_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDCollectionParser_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDCollectionParser_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDCollectionParser_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDParser_class(ctx);
        def.staticFunctions = TDCollectionParser_staticFunctions;
        def.staticValues = TDCollectionParser_staticValues;
        def.initialize = TDCollectionParser_initialize;
        def.finalize = TDCollectionParser_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDCollectionParser_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDCollectionParser_class(ctx), data);
}
