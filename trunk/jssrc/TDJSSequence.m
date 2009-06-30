//
//  PKJSSequence.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSSequence.h"
#import "PKJSUtils.h"
#import "TDJSCollectionParser.h"
#import <ParseKit/PKSequence.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDSequence_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDSequence_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDSequence_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDSequence_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDSequence_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDCollectionParser_class(ctx);
        def.staticFunctions = TDSequence_staticFunctions;
        def.staticValues = TDSequence_staticValues;
        def.initialize = TDSequence_initialize;
        def.finalize = TDSequence_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDSequence_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDSequence_class(ctx), data);
}

JSObjectRef TDSequence_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    PKSequence *data = [[PKSequence alloc] init];
    return TDSequence_new(ctx, data);
}
