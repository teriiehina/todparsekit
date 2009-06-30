//
//  PKJSCaseInsensitiveCaseInsensitiveLiteral.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSCaseInsensitiveLiteral.h"
#import "PKJSUtils.h"
#import "TDJSTerminal.h"
#import <ParseKit/PKCaseInsensitiveLiteral.h>

#pragma mark -
#pragma mark Methods

#pragma mark -
#pragma mark Properties

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDCaseInsensitiveLiteral_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDCaseInsensitiveLiteral_finalize(JSObjectRef this) {
    // released in TDParser_finalize
}

static JSStaticFunction TDCaseInsensitiveLiteral_staticFunctions[] = {
{ 0, 0, 0 }
};

static JSStaticValue TDCaseInsensitiveLiteral_staticValues[] = {        
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDCaseInsensitiveLiteral_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDTerminal_class(ctx);
        def.staticFunctions = TDCaseInsensitiveLiteral_staticFunctions;
        def.staticValues = TDCaseInsensitiveLiteral_staticValues;
        def.initialize = TDCaseInsensitiveLiteral_initialize;
        def.finalize = TDCaseInsensitiveLiteral_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDCaseInsensitiveLiteral_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDCaseInsensitiveLiteral_class(ctx), data);
}

JSObjectRef TDCaseInsensitiveLiteral_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "PKCaseInsensitiveLiteral");
    
    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);
    
    PKCaseInsensitiveLiteral *data = [[PKCaseInsensitiveLiteral alloc] initWithString:s];
    return TDCaseInsensitiveLiteral_new(ctx, data);
}
