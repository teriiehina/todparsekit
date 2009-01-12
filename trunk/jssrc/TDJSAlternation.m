//
//  TDJSAlternation.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSAlternation.h"
#import "TDJSUtils.h"
#import "TDJSCollectionParser.h"
#import <TDParseKit/TDAlternation.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDAlternation_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDAlternation_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDAlternation_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDAlternation_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDAlternation_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDCollectionParser_class(ctx);
        def.staticFunctions = TDAlternation_staticFunctions;
        def.staticValues = TDAlternation_staticValues;
        def.initialize = TDAlternation_initialize;
        def.finalize = TDAlternation_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDAlternation_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDAlternation_class(ctx), data);
}

JSObjectRef TDAlternation_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDAlternation *data = [[TDAlternation alloc] init];
    return TDAlternation_new(ctx, data);
}
