//
//  PKJSRepetition.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSRepetition.h"
#import "TDJSUtils.h"
#import "TDJSParser.h"
#import <ParseKit/PKRepetition.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDRepetition_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDRepetition_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDRepetition_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDRepetition_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDRepetition_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDParser_class(ctx);
        def.staticFunctions = TDRepetition_staticFunctions;
        def.staticValues = TDRepetition_staticValues;
        def.initialize = TDRepetition_initialize;
        def.finalize = TDRepetition_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDRepetition_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDRepetition_class(ctx), data);
}

JSObjectRef TDRepetition_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "PKRepetition");
	
	JSValueRef v = argv[0];
	if (!TDJSValueIsInstanceOfClass(ctx, v, "PKParser", ex)) {
		*ex = TDNSStringToJSValue(ctx, @"argument to TDRepeition constructor must be and instance of a PKParser subclass", ex);
	}
    
    PKParser *p = JSObjectGetPrivate((JSObjectRef)v);

    PKRepetition *data = [[PKRepetition alloc] initWithSubparser:p];
    return TDRepetition_new(ctx, data);
}
