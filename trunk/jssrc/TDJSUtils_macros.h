/*
 *  TDJSUtils_macros.h
 *  TDParseKit
 *
 *  Created by Todd Ditchendorf on 1/11/09.
 *  Copyright 2009 Todd Ditchendorf. All rights reserved.
 *
 */

#undef TDPreconditionInstaceOf
#define TDPreconditionInstaceOf(cls, meth) \
    if (!JSValueIsObjectOfClass(ctx, this, (cls)(ctx))) { \
        NSString *s = [NSString stringWithFormat:@"calling method '%s' on an object that is not an instance of '%s'", (meth), #cls]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return JSValueMakeUndefined(ctx); \
    }

#undef TDPreconditionMethodArgc
#define TDPreconditionMethodArgc(n, meth) \
    if (argc != (n)) { \
        NSString *s = [NSString stringWithFormat:@"%s() requires %d arguments", (meth), (n)]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return JSValueMakeUndefined(ctx); \
    }

#undef TDPreconditionConstructorArgc
#define TDPreconditionConstructorArgc(n, meth) \
    if (argc != (n)) { \
        NSString *s = [NSString stringWithFormat:@"%s constructor requires %d arguments", (meth), (n)]; \
        (*ex) = TDNSStringToJSValue(ctx, s, ex); \
        return NULL; \
    }

