//
//  TDNum.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDTerminal.h>

/*!
	@class       TDNum 
	@superclass  TDTerminal
	@abstract    A Num matches a number from a token assembly.
	@discussion  A Num matches a number from a token assembly.
*/
@interface TDNum : TDTerminal {

}

/*!
	@fn			num
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDNum</tt> object.
	@result     an initialized autoreleased <tt>TDNum</tt> object
*/
+ (id)num;
@end
