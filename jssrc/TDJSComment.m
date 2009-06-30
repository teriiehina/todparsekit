//
//  TDJSComment.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSComment.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/TDComment.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDComment_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDComment_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDComment_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDComment_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDComment_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDComment_staticFunctions;
        def.staticValues = TDComment_staticValues;
        def.initialize = TDComment_initialize;
        def.finalize = TDComment_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDComment_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDComment_class(ctx), data);
}

JSObjectRef TDComment_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDComment *data = [[TDComment alloc] init];
    return TDComment_new(ctx, data);
}
