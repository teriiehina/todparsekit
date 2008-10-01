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

/*!
	@method     setPreassembler:selector:
	@abstract   Sets the object that will work on every assembly before matching against it.
	@discussion Setting a preassembler is entirely optional, but sometimes useful for repetition parsers to do work on an assembly before matching against it.
	@param      a the assembler this parser will use to work on an assembly before matching against it.
	@param      sel a selector that assembler <tt>a</tt> responds to which will work on an assembly
*/
- (void)setPreassembler:(id)a selector:(SEL)sel;

/*!
	@method     
	@abstract   The assembler this parser will use to work on an assembly before matching against it.
	@discussion	<tt>preAssembler</tt> should respond to the selector held by this parser's <tt>preAssemblerSelector</tt> property.
*/
@property (nonatomic, retain) id preAssembler;

/*!
	@method     
	@abstract   The method of <tt>preAssembler</tt> this parser will call to work on an assembly.
	@discussion The method represented by <tt>preAssemblerSelector</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>preAssemblerSelector</tt> should be similar to: <tt>-workOnAssembly:(TDAssembly *)a</tt>.
*/
@property (nonatomic, assign) SEL preAssemblerSelector;
@end
