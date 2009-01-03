//
//  TDJSUtils.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

JSValueRef TDCFTypeToJSValue(JSContextRef ctx, CFTypeRef value);
JSValueRef TDCFStringToJSValue(JSContextRef ctx, CFStringRef cfStr);
JSValueRef TDNSStringToJSValue(JSContextRef ctx, NSString *nsStr);
JSObjectRef TDCFArrayToJSObject(JSContextRef ctx, CFArrayRef cfArray);
JSObjectRef TDCFDictionaryToJSObject(JSContextRef ctx, CFDictionaryRef cfDict);

CFTypeRef TDJSValueCopyCFType(JSContextRef ctx, JSValueRef value);
CFStringRef TDJSValueCopyCFString(JSContextRef ctx, JSValueRef value);
NSString *TDJSValueGetNSString(JSContextRef ctx, JSValueRef value);
CFArrayRef TDJSObjectCopyCFArray(JSContextRef ctx, JSObjectRef obj);
CFDictionaryRef TDJSObjectCopyCFDictionary(JSContextRef ctx, JSObjectRef obj);

JSObjectRef TDNSErrorToJSObject(JSContextRef ctx, NSError *nsErr);
bool TDJSValueIsInstanceOfClass(JSContextRef ctx, JSValueRef value, char *className, JSValueRef* ex);