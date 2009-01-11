//
//  TDJSParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/10/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDParser_new(JSContextRef ctx, void *data);
JSClassRef TDParser_class(JSContextRef ctx);
JSObjectRef TDParser_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef *ex);