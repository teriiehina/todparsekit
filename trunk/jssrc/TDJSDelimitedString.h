//
//  TDJSDelimitedString.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/1/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDDelimitedString_new(JSContextRef ctx, void *data);
JSClassRef TDDelimitedString_class(JSContextRef ctx);
JSObjectRef TDDelimitedString_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
