//
//  TDLiteral.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDLiteral.h"
#import "TDJSUtils.h"
#import "TDJSTerminal.h"
#import <TDParseKit/TDLiteral.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDLiteral_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDLiteral_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDLiteral_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDLiteral_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDLiteral_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDLiteral_staticFunctions;
        def.staticValues = TDLiteral_staticValues;
        def.initialize = TDLiteral_initialize;
        def.finalize = TDLiteral_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDLiteral_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDLiteral_class(ctx), data);
}

JSObjectRef TDLiteral_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "TDLiteral");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    TDLiteral *data = [[TDLiteral alloc] initWithString:s];
    return TDLiteral_new(ctx, data);
}
