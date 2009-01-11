//
//  TDJSTokenAssemblyAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/3/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDTokenAssembly_new(JSContextRef ctx, void *data);
JSClassRef TDTokenAssembly_class(JSContextRef ctx);
JSObjectRef TDTokenAssembly_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
