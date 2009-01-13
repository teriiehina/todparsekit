//
//  TDJSLowercaseWord.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/13/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSLowercaseWord.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <TDParseKit/TDLowercaseWord.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDLowercaseWord_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDLowercaseWord_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDLowercaseWord_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDLowercaseWord_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDLowercaseWord_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDWord_class(ctx);
        def.staticFunctions = TDLowercaseWord_staticFunctions;
        def.staticValues = TDLowercaseWord_staticValues;
        def.initialize = TDLowercaseWord_initialize;
        def.finalize = TDLowercaseWord_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDLowercaseWord_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDLowercaseWord_class(ctx), data);
}

JSObjectRef TDLowercaseWord_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "TDLowercaseWord");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDLowercaseWord *data = [[TDLowercaseWord alloc] initWithString:s];
    return TDLowercaseWord_new(ctx, data);
}
