//
//  TDJSCharacterAssembly.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSCharacterAssembly.h"
#import "TDJSUtils.h"
#import "TDJSAssembly.h"
#import <ParseKit/TDCharacterAssembly.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDCharacterAssembly_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCharacterAssembly_class, "toString");
    TDCharacterAssembly *data = JSObjectGetPrivate(this);
    JSStringRef resStr = JSStringCreateWithCFString((CFStringRef)[data description]);
    JSValueRef res = JSValueMakeString(ctx, resStr);
    JSStringRelease(resStr);
    return res;
}

static JSValueRef TDCharacterAssembly_pop(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCharacterAssembly_class, "pop");
    TDCharacterAssembly *data = JSObjectGetPrivate(this);
    NSNumber *obj = [data pop];
    return JSValueMakeNumber(ctx, [obj doubleValue]);
}

static JSValueRef TDCharacterAssembly_push(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCharacterAssembly_class, "push");
    TDPreconditionMethodArgc(1, "TDCharacterAssembly.push");
    
    JSValueRef v = argv[0];
    
    TDCharacterAssembly *data = JSObjectGetPrivate(this);
    id obj = TDJSValueGetId(ctx, v, ex);
    [data push:obj];
    
    return JSValueMakeUndefined(ctx);
}

static JSValueRef TDCharacterAssembly_objectsAbove(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDCharacterAssembly_class, "objectsAbove");
    TDPreconditionMethodArgc(1, "TDCharacterAssembly.objectsAbove");
    
    JSValueRef v = argv[0];
    
    TDCharacterAssembly *data = JSObjectGetPrivate(this);
    id obj = TDJSValueGetId(ctx, v, ex);
    id array = [data objectsAbove:obj];
    
    return TDNSArrayToJSObject(ctx, array, ex);
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDCharacterAssembly_getLength(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDCharacterAssembly *data = JSObjectGetPrivate(this);
    return JSValueMakeNumber(ctx, data.length);
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDCharacterAssembly_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDCharacterAssembly_finalize(JSObjectRef this) {
    // released in TDAssembly_finalize
}

static JSStaticFunction TDCharacterAssembly_staticFunctions[] = {
{ "toString", TDCharacterAssembly_toString, kJSPropertyAttributeDontDelete },        
{ "pop", TDCharacterAssembly_pop, kJSPropertyAttributeDontDelete },        
{ "push", TDCharacterAssembly_push, kJSPropertyAttributeDontDelete },        
{ "objectsAbove", TDCharacterAssembly_objectsAbove, kJSPropertyAttributeDontDelete },        
{ 0, 0, 0 }
};

static JSStaticValue TDCharacterAssembly_staticValues[] = {        
{ "length", TDCharacterAssembly_getLength, NULL, kJSPropertyAttributeDontDelete|kJSPropertyAttributeReadOnly }, // Number
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark ClassMethods

#pragma mark -
#pragma mark Public

JSClassRef TDCharacterAssembly_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.parentClass = TDAssembly_class(ctx);
        def.staticFunctions = TDCharacterAssembly_staticFunctions;
        def.staticValues = TDCharacterAssembly_staticValues;
        def.initialize = TDCharacterAssembly_initialize;
        def.finalize = TDCharacterAssembly_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDCharacterAssembly_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDCharacterAssembly_class(ctx), data);
}

JSObjectRef TDCharacterAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionConstructorArgc(1, "TDCharacterAssembly");
    
    JSValueRef s = argv[0];
    NSString *string = TDJSValueGetNSString(ctx, s, ex);
    
    TDCharacterAssembly *data = [[TDCharacterAssembly alloc] initWithString:string];
    return TDCharacterAssembly_new(ctx, data);
}
