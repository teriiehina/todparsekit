//
//  TDRepetition.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

/*!
    @class       TDRepetition 
    @superclass  TDParser
    @abstract    A <tt>TDRepetition</tt> matches its underlying parser repeatedly against a assembly.
    @discussion  A <tt>TDRepetition</tt> matches its underlying parser repeatedly against a assembly.
*/
@interface TDRepetition : TDParser {
	TDParser *subparser;
	id preAssembler;
	SEL preAssemblerSelector;
}

/*!
	@method     repetition
	@abstract   Convenience factory method for initializing an autoreleased <tt>TDRepetition</tt> parser.
	@result     an initialized autoreleased <tt>TDRepetition</tt> parser.
*/
+ (id)repetition;

/*!
    @method     repetitionWithSubparser:
    @abstract   Convenience factory method for initializing an autoreleased <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @param      p the subparser against wich to repeatedly match
    @result     an initialized autoreleased <tt>TDRepetition</tt> parser.
*/
+ (id)repetitionWithSubparser:(TDParser *)p;

/*!
    @method     initWithSubparser:
    @abstract   Designated Initializer. Initialize a <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @discussion Designated Initializer. Initialize a <tt>TDRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
	@param      p the subparser against wich to repeatedly match
	@result     an initialized <tt>TDRepetition</tt> parser.
*/
- (id)initWithSubparser:(TDParser *)p;
@end
