//
//  TDDelimitedString.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

/*!
    @class      TDDelimitedString
    @brief      A <tt>TDDelimitedString</tt> matches a delimited string from a token assembly.
*/
@interface TDDelimitedString : TDTerminal {
    NSString *startMarker;
    NSString *endMarker;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDDelimitedString</tt> object.
    @result     an initialized autoreleased <tt>TDDelimitedString</tt> object
*/
+ (id)delimitedString;

+ (id)delimitedStringWithStartMarker:(NSString *)start;

+ (id)delimitedStringWithStartMarker:(NSString *)start endMarker:(NSString *)end;
@end
