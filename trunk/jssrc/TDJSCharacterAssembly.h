//
//  TDJSCharacterAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/11/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDCharacterAssembly_new(JSContextRef ctx, void *data);
JSClassRef TDCharacterAssembly_class(JSContextRef ctx);
JSObjectRef TDCharacterAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
