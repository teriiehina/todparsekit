//
//  TDCollectionParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

/*!
	@class       TDCollectionParser 
	@superclass  TDParser
	@abstract    An Abstract class. This class abstracts the behavior common to parsers that consist of a series of other parsers.
	@discussion  An Abstract class. This class abstracts the behavior common to parsers that consist of a series of other parsers.
*/
@interface TDCollectionParser : TDParser {
	NSMutableArray *subparsers;
}

/*!
	@fn			add:
	@abstract   Adds a parser to the collection.
	@param      p parser to add
*/
- (void)add:(TDParser *)p;

/*!
	@fn			
	@abstract   This parser's subparsers.
*/
@property (nonatomic, readonly, retain) NSMutableArray *subparsers;
@end
