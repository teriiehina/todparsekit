//
//  TDTerminal.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

@class TDToken;

/*!
	@method     
	@abstract   An Abstract Class. A <tt>TDTerminal</tt> is a parser that is not a composition of other parsers.
	@discussion An Abstract Class. A <tt>TDTerminal</tt> is a parser that is not a composition of other parsers.
*/
@interface TDTerminal : TDParser {
	NSString *string;
	BOOL discard;
}

/*!
	@method     initWithString:
	@abstract   Designated Initializer for all concrete <tt>TDTerminal</tt> subclasses.
	@discussion Note this is an abtract class and this method must be called on a concrete subclass.
	@param      s the string matched by this parser
	@result     initialized <tt>TDTerminal</tt> subclass object
*/
- (id)initWithString:(NSString *)s;

/*!
	@method     discard
	@abstract   By default, terminals push themselves upon a assembly's stack, after a successful match. This method will turn off that behavior.
	@discussion This method returns this parser as a convenience for chainging-style usage.
	@result     this parser, returned for chaining/convenience
*/
- (TDTerminal *)discard;

/*!
	@method     
	@abstract   the string matched by this parser.
*/
@property (nonatomic, readonly, copy) NSString *string;
@end
