//
//  PKJSLowercaseWord.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 1/13/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

JSObjectRef TDLowercaseWord_new(JSContextRef ctx, void *data);
JSClassRef TDLowercaseWord_class(JSContextRef ctx);
JSObjectRef TDLowercaseWord_construct(JSContextRef ctx, JSObjectRef constructor, size_t argc, const JSValueRef argv[], JSValueRef* ex);
