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

}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>TDDelimitedString</tt> object.
    @result     an initialized autoreleased <tt>TDDelimitedString</tt> object
*/
+ (id)delimitedString;
@end
