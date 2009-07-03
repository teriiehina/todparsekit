//
//  PKRepetition.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKParser.h>

/*!
    @class      PKRepetition 
    @brief      A <tt>PKRepetition</tt> matches its underlying parser repeatedly against a assembly.
*/
@interface PKRepetition : PKParser {
    PKParser *subparser;
    id preassembler;
    SEL preassemblerSelector;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased <tt>PKRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @param      p the subparser against wich to repeatedly match
    @result     an initialized autoreleased <tt>PKRepetition</tt> parser.
*/
+ (id)repetitionWithSubparser:(PKParser *)p;

/*!
    @brief      Designated Initializer. Initialize a <tt>PKRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @details    Designated Initializer. Initialize a <tt>PKRepetition</tt> parser to repeatedly match against subparser <tt>p</tt>.
    @param      p the subparser against wich to repeatedly match
    @result     an initialized <tt>PKRepetition</tt> parser.
*/
- (id)initWithSubparser:(PKParser *)p;

/*!
    @brief      Sets the object that will work on every assembly before matching against it.
    @details    Setting a preassembler is entirely optional, but sometimes useful for repetition parsers to do work on an assembly before matching against it.
    @param      a the assembler this parser will use to work on an assembly before matching against it.
    @param      sel a selector that assembler <tt>a</tt> responds to which will work on an assembly
*/
- (void)setPreassembler:(id)a selector:(SEL)sel;

/*!
    @property   subparser
    @brief      this parser's subparser against which it repeatedly matches
*/
@property (nonatomic, readonly, retain) PKParser *subparser;

/*!
    @property   preassembler
    @brief      The assembler this parser will use to work on an assembly before matching against it.
    @discussion <tt>preassembler</tt> should respond to the selector held by this parser's <tt>preassemblerSelector</tt> property.
*/
@property (nonatomic, retain) id preassembler;

/*!
    @property   preAssemlerSelector
    @brief      The method of <tt>preassembler</tt> this parser will call to work on an assembly.
    @details    The method represented by <tt>preassemblerSelector</tt> must accept a single <tt>PKAssembly</tt> argument. The signature of <tt>preassemblerSelector</tt> should be similar to: <tt>- (void)workOnAssembly:(PKAssembly *)a</tt>.
*/
@property (nonatomic, assign) SEL preassemblerSelector;
@end
