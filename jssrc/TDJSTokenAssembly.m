//
//  PKJSTokenAssembly.m
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSTokenAssembly.h"
#import "TDJSToken.h"
#import "TDJSUtils.h"
#import "TDJSAssembly.h"
#import <ParseKit/PKTokenAssembly.h>
#import <ParseKit/PKToken.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDTokenAssembly_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenAssembly_class, "toString");
    PKTokenAssembly *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, [data description], ex);
}

static JSValueRef TDTokenAssembly_pop(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenAssembly_class, "pop");
    PKTokenAssembly *data = JSObjectGetPrivate(this);
    PKToken *tok = [data pop];
    return TDToken_new(ctx, tok);
}

static JSValueRef TDTokenAssembly_push(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenAssembly_class, "push");
    TDPreconditionMethodArgc(1, "PKTokenAssembly.push");
    
    JSValueRef v = argv[0];

    PKTokenAssembly *data = JSObjectGetPrivate(this);
    id obj = TDJSValueGetId(ctx, v, ex);
    [data push:obj];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDTokenAssembly_objectsAbove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDTokenAssembly_class, "objectsAbove");
    TDPreconditionMethodArgc(1, "PKTokenAssembly.objectsAbove");
    
    JSValueRef v = argv[0];
    
    PKTokenAssembly *data = JSObjectGetPrivate(this);
    id obj = TDJSValueGetId(ctx, v, ex);
    id array = [data objectsAbove:obj];
    
    return TDNSArrayToJSObject(ctx, array, ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDTokenAssembly_getLength(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    PKTokenAssembly *data = JSObjectGetPrivate(this);
    return JSValueMakeNumber(ctx, data.length);
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDTokenAssembly_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDTokenAssembly_finalize(JSObjectRef this) {
    // released in PKAssembly_finalize
}

static JSStaticFunction TDTokenAssembly_staticFunctions[] = {
{ "toString", TDTokenAssembly_toString, kJSPropertyAttributeDontDelete },        
{ "pop", TDTokenAssembly_pop, kJSPropertyAttributeDontDelete },        
{ "push", TDTokenAssembly_push, kJSPropertyAttributeDontDelete },        
{ "objectsAbove", TDTokenAssembly_objectsAbove, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDTokenAssembly_staticValues[] = {        
{ "length", TDTokenAssembly_getLength, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Number
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark ClassMethods

#pragma mark -
#pragma mark Public

JSClassRef TDTokenAssembly_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = PKAssembly_class(ctx);
        def.staticFunctions = TDTokenAssembly_staticFunctions;
        def.staticValues = TDTokenAssembly_staticValues;
        def.initialize = TDTokenAssembly_initialize;
        def.finalize = TDTokenAssembly_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDTokenAssembly_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDTokenAssembly_class(ctx), data);
}

JSObjectRef TDTokenAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "PKTokenAssembly");

    NSString *s = TDJSValueGetNSString(ctx, argv[0], ex);

    PKTokenAssembly *data = [[PKTokenAssembly alloc] initWithString:s];
    return TDTokenAssembly_new(ctx, data);
}
