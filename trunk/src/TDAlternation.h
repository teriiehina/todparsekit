//
//  TDAlternation.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDCollectionParser.h>

/*!
	@class       TDAlternation 
	@superclass  TDCollectionParser
	@abstract    A <tt>TDAlternation</tt> object is a collection of parsers, any one of which can successfully match against an assembly.
	@discussion  A <tt>TDAlternation</tt> object is a collection of parsers, any one of which can successfully match against an assembly.
*/
@interface TDAlternation : TDCollectionParser {

}

/*!
	@method     alternation
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDAlternation</tt> parser.
	@result     an initialized autoreleased <tt>TDAlternation</tt> parser.
*/
+ (id)alternation;
@end
