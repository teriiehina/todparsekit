//
//  TDJSParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJSParser.h"
#import "TDJSUtils.h"
#import "TDJSAssemblerAdapter.h"
#import "TDJSAssembly.h"
#import "TDJSTokenAssembly.h"
#import "TDJSCharacterAssembly.h"
#import <ParseKit/TDParser.h>
#import <ParseKit/PKAssembly.h>
#import <ParseKit/TDTokenAssembly.h>
#import <ParseKit/TDCharacterAssembly.h>

#pragma mark -
#pragma mark Methods

static JSValueRef TDParser_toString(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDParser_class, "toString");
    TDParser *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, [data description], ex);
}

static JSValueRef TDParser_bestMatch(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDParser_class, "bestMatch");
    TDPreconditionMethodArgc(1, "bestMatch");
    
    TDParser *data = JSObjectGetPrivate(this);

    JSObjectRef arg = (JSObjectRef)argv[0];
    PKAssembly *a = (PKAssembly *)JSObjectGetPrivate(arg);
    a = [data bestMatchFor:a];
    
    JSObjectRef result = NULL;
    if ([a isMemberOfClass:[TDTokenAssembly class]]) {
        result = TDTokenAssembly_new(ctx, a);
    } else if ([a isMemberOfClass:[TDCharacterAssembly class]]) {
        result = TDCharacterAssembly_new(ctx, a);
    }

    return result;
}

static JSValueRef TDParser_completeMatch(JSContextRef ctx, JSObjectRef function, JSObjectRef this, size_t argc, const JSValueRef argv[], JSValueRef *ex) {
    TDPreconditionInstaceOf(TDParser_class, "completeMatch");
    TDPreconditionMethodArgc(1, "completeMatch");
    
    TDParser *data = JSObjectGetPrivate(this);
    
    JSObjectRef arg = (JSObjectRef)argv[0];
    PKAssembly *a = (PKAssembly *)JSObjectGetPrivate(arg);
    a = [data completeMatchFor:a];
    
    JSObjectRef result = NULL;
    if ([a isMemberOfClass:[TDTokenAssembly class]]) {
        result = TDTokenAssembly_new(ctx, a);
    } else if ([a isMemberOfClass:[TDCharacterAssembly class]]) {
        result = TDCharacterAssembly_new(ctx, a);
    }
    
    return result;
}

#pragma mark -
#pragma mark Properties

static JSValueRef TDParser_getAssembler(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDParser *data = JSObjectGetPrivate(this);
    id assembler = data.assembler;
    if ([assembler isMemberOfClass:[TDJSAssemblerAdapter class]]) {
        return [assembler assemblerFunction];
    } else {
        return NULL;
    }
}

static bool TDParser_setAssembler(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    if (!JSValueIsObject(ctx, value) || !JSObjectIsFunction(ctx, (JSObjectRef)value)) {
        (*ex) = TDNSStringToJSValue(ctx, @"only a function object can be set as a parser's assembler property", ex);
        return false;
    }
    
    TDParser *data = JSObjectGetPrivate(this);
    TDJSAssemblerAdapter *adapter = [[TDJSAssemblerAdapter alloc] init]; // retained. released in TDParser_finalize
    [adapter setAssemblerFunction:(JSObjectRef)value fromContext:ctx];
    [data setAssembler:adapter selector:@selector(workOn:)];
    return true;
}

static JSValueRef TDParser_getName(JSContextRef ctx, JSObjectRef this, JSStringRef propName, JSValueRef *ex) {
    TDParser *data = JSObjectGetPrivate(this);
    return TDNSStringToJSValue(ctx, data.name, ex);
}

static bool TDParser_setName(JSContextRef ctx, JSObjectRef this, JSStringRef propertyName, JSValueRef value, JSValueRef *ex) {
    TDParser *data = JSObjectGetPrivate(this);
    data.name = TDJSValueGetNSString(ctx, value, ex);
    return true;
}

#pragma mark -
#pragma mark Initializer/Finalizer

static void TDParser_initialize(JSContextRef ctx, JSObjectRef this) {
    
}

static void TDParser_finalize(JSObjectRef this) {
    TDParser *data = (TDParser *)JSObjectGetPrivate(this);
    id assembler = data.assembler;
    data.assembler = nil;
    if ([assembler isMemberOfClass:[TDJSAssemblerAdapter class]]) {
        [assembler autorelease];
    }
    [data autorelease];
}

static JSStaticFunction TDParser_staticFunctions[] = {
{ "toString", TDParser_toString, kJSPropertyAttributeDontDelete },
{ "bestMatch", TDParser_bestMatch, kJSPropertyAttributeDontDelete },
{ "completeMatch", TDParser_completeMatch, kJSPropertyAttributeDontDelete },
{ 0, 0, 0 }
};

static JSStaticValue TDParser_staticValues[] = {        
{ "assembler", TDParser_getAssembler, TDParser_setAssembler, kJSPropertyAttributeDontDelete }, // Function
{ "name", TDParser_getName, TDParser_setName, kJSPropertyAttributeDontDelete }, // String
{ 0, 0, 0, 0 }
};

#pragma mark -
#pragma mark Public

JSClassRef TDParser_class(JSContextRef ctx) {
    static JSClassRef jsClass = NULL;
    if (!jsClass) {                
        JSClassDefinition def = kJSClassDefinitionEmpty;
        def.staticFunctions = TDParser_staticFunctions;
        def.staticValues = TDParser_staticValues;
        def.initialize = TDParser_initialize;
        def.finalize = TDParser_finalize;
        jsClass = JSClassCreate(&def);
    }
    return jsClass;
}

JSObjectRef TDParser_new(JSContextRef ctx, void *data) {
    return JSObjectMake(ctx, TDParser_class(ctx), data);
}
