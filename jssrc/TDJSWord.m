//
//  PKJSWord.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSWord.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKWord.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDWord_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDWord_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDWord_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDWord_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDWord_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDWord_staticFunctions;
        def.staticValues = TDWord_staticValues;
        def.initialize = TDWord_initialize;
        def.finalize = TDWord_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDWord_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDWord_class(ctx), data);
}

JSObjectRef TDWord_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    PKWord *data = [[PKWord alloc] init];
    return TDWord_new(ctx, data);
}
