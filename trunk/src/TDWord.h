//
//  TDWord.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

/*!
    @class       TDWord 
    @superclass  TDTerminal
	@abstract    A <tt>TDWord</tt> matches a word from a token assembly.
    @discussion  A <tt>TDWord</tt> matches a word from a token assembly.
*/
@interface TDWord : TDTerminal {

}

/*!
	@method     word
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDWord</tt> object.
	@result     an initialized autoreleased <tt>TDWord</tt> object
*/
+ (id)word;
@end
