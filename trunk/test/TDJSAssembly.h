//
//  TDJSAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDAssembly_new(JSContextRef ctx, void *data);
JSClassRef TDAssembly_class(JSContextRef ctx);
JSObjectRef TDAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
